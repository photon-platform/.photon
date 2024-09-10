import os

def generate_markdown(folder_path, output_file):
    with open(output_file, 'w') as md_file:
        for root, dirs, files in os.walk(folder_path):
            for file in files:
                if file.endswith('.sh'):
                    file_path = os.path.join(root, file)
                    with open(file_path, 'r') as sh_file:
                        content = sh_file.read()
                    relative_path = os.path.relpath(file_path, folder_path)
                    md_file.write(f"## {relative_path}\n")
                    md_file.write("```sh\n")
                    md_file.write(content)
                    md_file.write("\n```\n\n")

if __name__ == "__main__":
    folder_path = "."  # Replace with the path to your folder
    output_file = "gather_sites.md"
    generate_markdown(folder_path, output_file)

