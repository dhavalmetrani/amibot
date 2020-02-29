"""
Displays the help.
"""
import os

def main():
  """
  Display the help.
  """
  file_path = os.path.abspath(__file__)
  file_path = file_path[:file_path.rfind("/")]
  print("The following commands are available: ")
  print("```")
  for file in os.listdir(file_path):
    if (file.endswith(".py")):
      print("- " + file[:len(file)-3])
  print("```")



if __name__ == '__main__':
  main()
