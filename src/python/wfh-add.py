"""
Add new wfh.
e.g. wfh-add @dhaval
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
  if len(sys.argv) <= 1:
    print("Please specify a user to add. e.g. wfh-add @amithkumar")
    exit(1)
  else:
    user_to_add = sys.argv[1].lower()
    # print(user_to_add)
    util.add_wfh(user_to_add, str(current_date))
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
