#! /usr/bin/env python3

import logging
import sys

import PyQt5

import UI

if "__main__" == __name__:
    print("Project Stub App Starting")

    logging.basicConfig(filename="project_stub_app.log",
                        level=logging.DEBUG,
                        format='%(asctime)s,%(levelname)s,%(message)s',
                        datefmt='%m/%d/%Y %I:%M:%S %p')

    logging.info("Project Stub App Program Starting")

    app = PyQt5.QtWidgets.QApplication(sys.argv)
    gui = UI.UI()
    gui.show()
    app.exec_()

    # All done, log it and exit
    logging.info("Project Stub App Terminated")
    sys.exit(0)
