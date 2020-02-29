"""
List all wfh.
e.g. wfh-list
e.g. wfh-list 2020-02-29
"""
import sys
import requests
import lib.util as util

def main():
  """
  Main function.
  """
  # print(len(sys.argv))
  # print(sys.argv[0])
  current_date = str(util.get_today())
  if len(sys.argv) > 1:
    current_date = sys.argv[1]
  print("The following members have reported wfh on `{}` so far: ".format(current_date))
  print("```")
  if len(util.get_wfh(str(current_date))) == 0:
    print("None")
  for _ in util.get_wfh(str(current_date)):
    print("- {}".format(_))
  print("```")


if __name__ == '__main__':
  """
  Main guard.
  """
  main()
