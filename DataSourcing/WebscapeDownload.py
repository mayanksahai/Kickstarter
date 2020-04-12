from bs4 import BeautifulSoup
import urllib.request
import requests
import pathlib
import os
import time

def findLinks():
    cwd = os.getcwd()
    file_name_prefix = "kickstarter"
    folder = cwd + "\\datasets\\"
    resp = urllib.request.urlopen("https://webrobots.io/kickstarter-datasets/")
    soup = BeautifulSoup(resp, from_encoding=resp.info().get_param('charset'))
    hrefs = soup.find_all('a', href=True)

    download_links = []
    for link in hrefs:
        #print(link['href'])
        download_links.append(link['href'])

    download_links = (list(filter(lambda x: x.endswith('.zip') and  ("json" not in x), download_links)))

    file_number = 0
    for download_link in download_links:
       file_name = "%s%s%s%s"%(folder,file_name_prefix,file_number,".zip")
       print("will download content of {} and save in {}".format(download_link,file_name))
       if not os.path.exists(file_name):
         time.sleep(3)
         download_url(download_link,file_name)
         print("successfully downloaded content in {}".format(file_name))
         file_number += 1
       else:
        file_number += 1
        print("file already exists {}".format(file_name))

def download_url(url, save_path, chunk_size=512 * 1024):
    r = requests.get(url, stream=True)
    with open(save_path, 'wb') as fd:
        for chunk in r.iter_content(chunk_size=chunk_size):
            fd.write(chunk)

def download_file(url,save_path):
    local_filename = url.split('/')[-1]
    # NOTE the stream=True parameter below
    with requests.get(url, stream=True) as r:
        r.raise_for_status()
        with open(save_path, 'wb',r.encoding) as f:
            print ("streaming content...")
            for chunk in r.iter_content(chunk_size=8192):
                if chunk: # filter out keep-alive new chunks
                    f.write(chunk)
                    # f.flush()
    return local_filename

def download_url2(url, save_path):
    response = urllib.request.urlopen(url)
    zipContent = response.read()
    with open(save_path, 'wb') as f:
        f.write(zipContent)

if __name__ == "__main__":
    findLinks()