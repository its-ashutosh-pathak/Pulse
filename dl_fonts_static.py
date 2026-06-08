import urllib.request
import os

fonts = ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold']
dir_path = os.path.join('assets', 'fonts')
os.makedirs(dir_path, exist_ok=True)

for w in fonts:
    file = 'Outfit-' + w + '.ttf'
    url = 'https://github.com/google/fonts/raw/main/ofl/outfit/static/' + file
    dest = os.path.join(dir_path, file)
    print("Downloading " + file + " from " + url)
    urllib.request.urlretrieve(url, dest)
