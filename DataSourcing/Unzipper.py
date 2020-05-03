import os, zipfile
import glob
import pandas as pd
import re
from xlsxwriter.workbook import Workbook
import csv

cwd = os.getcwd()
zip_files_folder = cwd + "\\zipFiles\\"
data_set_folder = cwd + "\\dataSets\\"
merged_file_name = data_set_folder + "KickstarterMerged.csv"


def unzip():
    if os.path.exists(data_set_folder) and len(os.listdir(data_set_folder)) == 0:
        extension = ".zip"
        for item in os.listdir(zip_files_folder):  # loop through items in dir
            if item.endswith(extension):  # check for ".zip" extension
                file_name = zip_files_folder + item  # get full path of files
                file_date_regex = re.compile("Kickstarter_((\d+-)+\d+).zip")
                file_date_name = file_date_regex.search(file_name)
                file_date = file_date_name.group(1)
                zip_ref = zipfile.ZipFile(file_name)  # create zipfile object
                zip_infos = zip_ref.infolist()
                for zip_info in zip_infos:
                    filename, ext = os.path.splitext(zip_info.filename)
                    # This will do the renaming
                    zip_info.filename = filename + "_" + file_date + ext
                    zip_ref.extract(zip_info, data_set_folder)
                # zip_ref.extractall(data_set_folder)  # extract file to dir
                zip_ref.close()  # close file
                # os.remove(file_name) # delete zipped file


def merge_csv():
    if not os.path.exists(merged_file_name):
        extension = ".zip"
        all_files = glob.glob(os.path.join(data_set_folder, "Kickstarter*.csv"))
        all_df = []
        for f in all_files:
            df = pd.read_csv(f, sep=',')
            df['file'] = f.split('/')[-1]
            all_df.append(df)

        merged_df = pd.concat(all_df, ignore_index=True, sort=True)
        merged_df.to_csv(merged_file_name)
        print("successfully merged all csv files into {}".format(merged_file_name))


def convert_to_excel():
    if os.path.exists(merged_file_name):
        for csvfile in glob.glob(os.path.join(data_set_folder, "*Merged.csv")):
            workbook = Workbook(csvfile[:-4] + '.xlsx', {'constant_memory': True})
            workbook.use_zip64()
            worksheet = workbook.add_worksheet()
            with open(csvfile, 'rt', encoding='utf8') as f:
                reader = csv.reader(f)
                for r, row in enumerate(reader):
                    for c, col in enumerate(row):
                        worksheet.write(r, c, col)
            workbook.close()
            print("successfully converted csv files into {}.xlsx".format(merged_file_name))


def convert_to_excel_pandas():
    if os.path.exists(merged_file_name):
        read_file = pd.read_csv(r'C:\Mtech\Sem1Project\Kickstarter\DataSourcing\dataSets\KickstarterMerged.csv')
        read_file.to_excel(r'C:\Mtech\Sem1Project\Kickstarter\DataSourcing\dataSets\KickstarterData.xlsx', index=None, header=True)
        print("successfully converted csv files into.xlsx")


if __name__ == "__main__":
    # unzip()
    # merge_csv()
    convert_to_excel()
