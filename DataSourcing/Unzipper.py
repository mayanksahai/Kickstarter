import os, zipfile
import glob
import pandas as pd

merged_file_name = "C:\Mtech\Sem1Project\Kickstarter\DataSourcing\datasets\KickstarterMerged.csv"

def unzip():
    if not os.path.exists(merged_file_name):
        dir_name = 'C:\\Mtech\\Sem1Project\\Kickstarter\\DataSourcing\\datasets\\'
        extension = ".zip"
        for item in os.listdir(dir_name): # loop through items in dir
            if item.endswith(extension): # check for ".zip" extension
                file_name = dir_name+item # get full path of files
                zip_ref = zipfile.ZipFile(file_name) # create zipfile object
                zip_ref.extractall(dir_name) # extract file to dir
                zip_ref.close() # close file
                #os.remove(file_name) # delete zipped file


def merge_csv():
    if not os.path.exists(merged_file_name):
        dir_name = 'C:\\Mtech\\Sem1Project\\Kickstarter\\DataSourcing\\datasets\\'
        extension = ".zip"
        all_files = glob.glob(os.path.join(dir_name, "Kickstarter*.csv"))
        all_df = []
        for f in all_files:
            df = pd.read_csv(f, sep=',')
            df['file'] = f.split('/')[-1]
            all_df.append(df)

        merged_df = pd.concat(all_df, ignore_index=True, sort=True)
        merged_df.to_csv(merged_file_name)

if __name__ == "__main__":
    unzip()
    merge_csv()