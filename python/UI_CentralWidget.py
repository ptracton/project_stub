
import time

import PyQt5
import PyQt5.QtWidgets
import PyQt5.QtGui
import PyQt5.QtCore

import SerialPortUI
from constants import *


class UI_CentralWidget(PyQt5.QtWidgets.QDialog):
    """
    This class holds the GUI elements
    """

    def __init__(self, parent=None):
        super(UI_CentralWidget, self).__init__(parent)

        topVboxLayout = PyQt5.QtWidgets.QVBoxLayout()
        self.mySerialPort = SerialPortUI.SerialPortUI()
        self.mySerialPort.connectButtonSignal.connect(self.serialPortConnect)
        topVboxLayout.addLayout(self.mySerialPort.getLayout())
        self.setLayout(topVboxLayout)

        return

    def serialPortConnect(self):
        """
        Serial Port Connected
        """
        # print("UI Central Widget serial Port Connect")
        identification = self.mySerialPort.serial_port.CPU_Read(
            SYSCON_R_IDENTIFICATION)
        # print("SYSCON IDENTIFICATION {:08x}".format(identification))
        self.mySyscon.updateIdentification(identification)

        control = self.mySerialPort.serial_port.CPU_Read(SYSCON_R_CONTROL)
        self.mySyscon.SysconControlLineEdit.setText("{:08x}".format(control))

        status = self.mySerialPort.serial_port.CPU_Read(SYSCON_R_STATUS)
        # print("SYSCON STATUS {:08x}".format(status))
        if status & B_SYSCON_STATUS_LOCKED:
            self.mySyscon.SysconStatusLockedCheckBox.setChecked(True)
