import getpass
import re
import os
from command import Command

class Workflow(object):
    """
    Wrappers for each step of the data analysis workflow
    """
    def __init__(self,
                renku_cli = '/home/rstudio/.local/bin/renku',
                **kwargs):
        self.renku_cli = renku_cli
        git_repo = Command(["git",
                             "config",
                             "--get",
                             "remote.origin.url"
                            ]
                           ).stdout.read().decode()
        self.renku_dir = os.path.join("/home/rstudio",
            re.sub(r".*/|\.git$|\n", "", git_repo),
            ".renku"
        )
        self.__dict__.update(kwargs)

    def __get_dataset_metadata(self, dataset_name):
        """
        Retrieve the metadata file associated with a renku dataset
        Returns: path to the renku dataset metadata file
        """
        metadata = Command([self.renku_cli, 'dataset'])
        metadata.pipe(['grep', '-w', re.sub("[^A-Za-z0-9]+", "", dataset_name)])
        metadata.pipe(['cut', '-d', ' ', '-f1'])
        metadata_fp = os.path.join(self.renku_dir,
                       "datasets",
                       metadata.stdout.read().decode().splitlines()[0],
                       "metadata.yml"
                      )
        return metadata_fp

    def slims_fetch(self, **kwargs):
        """
        Wrapper for slims-lisp fetch
        Returns: path to the downloaded file
        """
        print("Fetching data from SLIMS...")
        opts = {
            "url": "SLIMS REST URL (ex: https://<your_slims_address>/rest/rest)",
            "proj": "Project name (if any)",
            "exp": 'Experiment name',
            "step": "Experiment step name (ex: 'data_collection')",
            "attm": "Attachment name (ex: 'count_data.xlsx')",
            "output_dir": 'Output directory',
            "user": 'SLIMS user name'
        }
        for key, val in opts.items():
            if key not in kwargs.keys():
                if key in self.__dict__.keys():
                    kwargs[key] = self.__dict__[key]
                else:
                    kwargs[key] = input(val + ": ")
                
        cmd = Command(['slims-lisp', 'fetch',
                         '--url', kwargs["url"],
                         '--proj', kwargs["proj"],
                         '--exp', kwargs["exp"],
                         '--step', kwargs["step"],
                         '--attm', kwargs["attm"],
                         '--output_dir', kwargs["output_dir"],
                         '-v',
                         '-u', kwargs['user'],
                         '-p', getpass.getpass("SLIMS password: ")
                      ]
                     )
        print(cmd.stdout.read().decode() + cmd.stderr.read().decode())
        return os.path.join(kwargs["output_dir"], kwargs["attm"])

    def slims_add_dataset(self, **kwargs):
        """
        Wrapper for slims-lisp add-dataset
        """
        print("Uploading files to SLIMS...")
        opts = {
            "url": "SLIMS REST URL (ex: https://<your_slims_address>/rest/rest)",
            "proj": "Project name (if any)",
            "exp": 'Experiment name',
            "files": 'Comma-delimited paths to the files that will be uploaded',
            "title": 'Title of the attachment block that will be created for the \
dataset in SLIMS.  [default: dataset_<ISO 8601 timestamp>]',
            "user": 'User name'
        }
        for key, val in opts.items():
            if key not in kwargs.keys():
                if key in self.__dict__.keys():
                    kwargs[key] = self.__dict__[key]
                else:
                    kwargs[key] = input(val + ": ")
                
        cmd = Command(['slims-lisp', 'add-dataset',
                         '--url', kwargs["url"],
                         '--proj', kwargs["proj"],
                         '--exp', kwargs["exp"],
                         '--files', kwargs["files"],
                         '--title', kwargs["title"],
                         '-v',
                         '-u', kwargs['user'],
                         '-p', getpass.getpass("SLIMS password: ")
                      ]
                     )
        print(cmd.stdout.read().decode() + cmd.stderr.read().decode())
    
    def dataset_create(self, **kwargs):
        """
        Wrapper for renku dataset create
        Returns: path to the renku dataset metadata file
        """
        print("Creating RENKU dataset...")
        opts = {
            "dataset_name": "Dataset name"
        }
        for key, val in opts.items():
            if key not in kwargs.keys():
                if key in self.__dict__.keys():
                    kwargs[key] = self.__dict__[key]
                else:
                    kwargs[key] = input(val + ": ")

        cmd = Command([self.renku_cli,
                        'dataset',
                        'create',
                        kwargs["dataset_name"]
                      ]
                     )
        print(cmd.stdout.read().decode() + cmd.stderr.read().decode())
        return self.__get_dataset_metadata(kwargs["dataset_name"])
    
    def dataset_add(self, **kwargs):
        """
        Wrapper for renku dataset add
        Returns: path to the renku dataset metadata file
        """
        print("Adding file to RENKU dataset...")
        opts = {
            "dataset_name": "Dataset name",
            "file": "File"
        }

        for key, val in opts.items():
            if key not in kwargs.keys():
                if key in self.__dict__.keys():
                    kwargs[key] = self.__dict__[key]
                else:
                    kwargs[key] = input(val + ": ")

        if os.path.isdir(kwargs["file"]):
            kwargs["file"] = [os.path.join(kwargs["file"], e)
                              for e in os.listdir(kwargs["file"])
                             if os.path.isfile(os.path.join(kwargs["file"], e))]
        else:
            kwargs["file"] = [kwargs["file"]]

        for file in kwargs["file"]:
            cmd = Command([self.renku_cli,
                            'dataset',
                            'add',
                            kwargs["dataset_name"],
                            file
                          ]
                         )
            print(cmd.stdout.read().decode() + cmd.stderr.read().decode())
            
        return self.__get_dataset_metadata(kwargs["dataset_name"])

    def build_survival_curves(self, **kwargs):
        """
        Wrapper for bin/build_survival_curves.R
        """
        print("Analyzing survival data...")
        opts = {
            "input_fp": "Path to the xlsx input file",
            "model": "Statistical model (ex: 'Strain+Treatment')",
            "output_dir": "Path to the output directory. Default: data"
        }
        for key, val in opts.items():
            if key not in kwargs.keys():
                if key in self.__dict__.keys():
                    kwargs[key] = self.__dict__[key]
                else:
                    kwargs[key] = input(val + ": ")
                
        cmd = Command(['bin/build_survival_curves.R',
                       '--input_fp', kwargs["input_fp"],
                       '--model', kwargs["model"],
                       '--output_dir', kwargs["output_dir"]
                      ]
                     ) 
        print(cmd.stdout.read().decode() + cmd.stderr.read().decode())
