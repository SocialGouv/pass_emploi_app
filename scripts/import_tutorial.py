import csv
import hashlib
import os
import subprocess
import time
import urllib.request

### Utilisation
# Depuis la feuille (Import-Jeunes), exporter au format csv le tutoriel
# Le placer dans le dossier $csv_path (cf. constantes)
# Lancer le script :
# python scripts/import_tutorial.py

### Constantes

assets_path = "assets/tuto"
dart_file_path = "lib/models/tutorial/tutorial.dart"
csv_path = "lib/models/tutorial/tutorial_data.csv"

### Code

class Page:
    def __init__(self, title, description, image_url):
        self.title = self.sanitize(title)
        self.description = self.sanitize(description)
        self.image_url = image_url
        self.image_path = self.image_path(image_url)

    def image_hash(self, image_url):
        hash_object = hashlib.sha256(image_url.encode())
        hash_value = hash_object.hexdigest()
        return hash_value

    def image_path(self, image_url):
        name = self.image_hash(image_url)
        return f"{assets_path}/{name}.svg"

    def sanitize(self, text):
        return text.replace('"', '\\"')

    def __str__(self):
        return f"TutorialPage(title: \"{self.title}\", description: \"{self.description}\", image: \"{self.image_path}\",)"

class Tutorial:
    def __init__(self, milo, pe):
        self.milo = milo
        self.pe = pe

    def version(self):
        return str(int(time.time()))

    def pages_to_dart(self, structure, pages):
        result = f"static List<TutorialPage> {structure} = [\n"
        for page in pages:
            result += str(page) + ",\n"
        result += "];\n"
        return result

    def download_images(self):
        for page in self.milo:
            self.download_image(page.image_url, page.image_path)
        for page in self.pe:
            self.download_image(page.image_url, page.image_path)

    def download_image(self, url, path):
        urllib.request.urlretrieve(url, path)

    def write_to_dart_file(self):
        with open(dart_file_path, 'w') as file:
            file.write(str(self))
        dart_format(dart_file_path)

    def __str__(self):
        result = "import 'package:pass_emploi_app/models/tutorial/tutorial_page.dart';\n"
        result += "class Tutorial {\n"
        result += f"static const String version = '{self.version()}';\n"
        result += self.pages_to_dart("milo", self.milo)
        result += self.pages_to_dart("pe", self.pe)
        result += "}"
        return result

def parse_csv():
    milo_pages = []
    pe_pages = []
    
    with open(csv_path, 'r', newline='') as csvfile:
        reader = csv.reader(csvfile)

        next(reader)  # Skip header row
        
        for row in reader:
            structure = row[1]
            title = row[2]
            description = row[4]
            image_url = row[6]
            
            page = Page(title, description, image_url)

            if "milo" in structure:
                milo_pages.append(page)
            if "pe" in structure:
                pe_pages.append(page)
    
    return Tutorial(milo_pages, pe_pages)

def delete_files_in_folder(folder_path):
    for filename in os.listdir(folder_path):
        file_path = os.path.join(folder_path, filename)
        if os.path.isfile(file_path):
            os.remove(file_path)

def dart_format(path):
    process = subprocess.Popen(f"dart format '{path}' 120", shell=True)
    process.communicate()

### Main

if __name__ == '__main__':
    delete_files_in_folder(assets_path)
    tutorial = parse_csv()
    tutorial.download_images()
    tutorial.write_to_dart_file()