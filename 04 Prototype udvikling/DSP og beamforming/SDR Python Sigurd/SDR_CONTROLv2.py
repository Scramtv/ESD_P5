import sys
import json
import pyvisa

import time
import os
from PyQt5.QtWidgets import (
    QApplication, QWidget, QPushButton, QVBoxLayout, QTextEdit,
    QFileDialog, QLabel, QLineEdit, QHBoxLayout, QSpinBox
)
from PyQt5.QtGui import QIcon
from RsInstrument import RsInstrument
#from SDRsigGen import untitled  # Import your GNU Radio flowgraph
from PyQt5.QtCore import QTimer


class SCPICommandExecutor(QWidget):
    def __init__(self):
        super().__init__()
        self.initUI()
        self.smb = None
        self.fsw = None
        self.run_counter = 1
        self.gain_range = []

        # Launch GNU Radio TX flowgraph
        #self.tx = untitled() 
        #self.tx.start()
        #self.tx.show()

    def initUI(self):
        self.setWindowTitle("Satillite Communication Testbed Control Toolbox")
        self.setGeometry(100, 100, 600, 600)
        self.setWindowIcon(QIcon("C:\\Users\\sigur\\Documents\\Semester 10\\Code\\icon.png"))

        layout = QVBoxLayout()

        self.label_use_case = QLabel("Select Use Case: Sub-THz 6G Waveform")
        layout.addWidget(self.label_use_case)

        # SFI connection
        self.label_sfi = QLabel("Enter SMBV100B IP Address:")
        self.sfi_ip = QLineEdit()
        self.connect_sfi_button = QPushButton("Connect SMBV100B")
        self.disconnect_sfi_button = QPushButton("Disconnect SMBV100B")
        self.connect_sfi_button.clicked.connect(self.connect_sfi)
        self.disconnect_sfi_button.clicked.connect(self.disconnect_sfi)

        sfi_layout = QHBoxLayout()
        sfi_layout.addWidget(self.label_sfi)
        sfi_layout.addWidget(self.sfi_ip)
        sfi_layout.addWidget(self.connect_sfi_button)
        sfi_layout.addWidget(self.disconnect_sfi_button)
        layout.addLayout(sfi_layout)

        # FSW connection
        self.label_fsw = QLabel("Enter FSW IP Address:")
        self.fsw_ip = QLineEdit()
        self.connect_fsw_button = QPushButton("Connect FSW")
        self.disconnect_fsw_button = QPushButton("Disconnect FSW")
        self.connect_fsw_button.clicked.connect(self.connect_fsw)
        self.disconnect_fsw_button.clicked.connect(self.disconnect_fsw)

        fsw_layout = QHBoxLayout()
        fsw_layout.addWidget(self.label_fsw)
        fsw_layout.addWidget(self.fsw_ip)
        fsw_layout.addWidget(self.connect_fsw_button)
        fsw_layout.addWidget(self.disconnect_fsw_button)
        layout.addLayout(fsw_layout)

        # JSON loader
        self.load_button = QPushButton("Load JSON")
        self.load_button.clicked.connect(self.load_json)
        layout.addWidget(self.load_button)

        # Frequency start index
        self.start_freq_label = QLabel("Start Frequency Index:")
        self.start_freq_input = QSpinBox()
        self.start_freq_input.setMinimum(0)
        self.start_freq_input.setValue(0)
        freq_layout = QHBoxLayout()
        freq_layout.addWidget(self.start_freq_label)
        freq_layout.addWidget(self.start_freq_input)
        layout.addLayout(freq_layout)

        # Gain start index
        self.start_gain_label = QLabel("Start Gain Index:")
        self.start_gain_input = QSpinBox()
        self.start_gain_input.setMinimum(0)
        self.start_gain_input.setValue(0)
        gain_layout = QHBoxLayout()
        gain_layout.addWidget(self.start_gain_label)
        gain_layout.addWidget(self.start_gain_input)
        layout.addLayout(gain_layout)

        # Interval
        self.interval_label = QLabel("Interval Between Executions (seconds):")
        self.interval_input = QSpinBox()
        self.interval_input.setMinimum(0)
        self.interval_input.setValue(0)

        interval_layout = QHBoxLayout()
        interval_layout.addWidget(self.interval_label)
        interval_layout.addWidget(self.interval_input)
        layout.addLayout(interval_layout)

        # Measurement count per frequency
        self.execution_count_label = QLabel("Measurements per Frequency:")
        self.execution_count_input = QSpinBox()
        self.execution_count_input.setMinimum(1)
        self.execution_count_input.setMaximum(1000000)
        self.execution_count_input.setValue(1)

        execution_layout = QHBoxLayout()
        execution_layout.addWidget(self.execution_count_label)
        execution_layout.addWidget(self.execution_count_input)
        layout.addLayout(execution_layout)

        # Execute
        self.execute_button = QPushButton("Execute Commands")
        self.execute_button.clicked.connect(self.execute_multiple_commands)
        layout.addWidget(self.execute_button)

        # Output box
        self.text_edit = QTextEdit()
        self.text_edit.setReadOnly(True)
        layout.addWidget(self.text_edit)

        self.setLayout(layout)

    def execute_multiple_commands(self):
        if not hasattr(self, 'command_data') or not isinstance(self.command_data, dict):
            self.text_edit.append("No valid JSON loaded.")
            return

        self.text_edit.append("Starting External Triggered Measurement...")

        execution_count = self.execution_count_input.value()
        interval = self.interval_input.value()

        for _ in range(execution_count):
            self.execute_commands(freq=None, gain=None)
            self.run_counter += 1
            if interval > 0:
                time.sleep(interval)


    def execute_commands(self, freq, gain):
        try:
            if not hasattr(self, 'command_data') or not isinstance(self.command_data, dict):
                self.text_edit.append("No valid JSON loaded.")
                return

            for cmd in self.command_data.get("commands", []):
                # Handle both string and dict entries
                if isinstance(cmd, str):
                    instrument_key = "fsw"  # or "smbv" depending on what these commands are for
                    scpi_command = cmd
                elif isinstance(cmd, dict):
                    instrument_key = cmd.get("instrument", "").lower()
                    scpi_command = cmd.get("scpi", "")
                else:
                    self.text_edit.append(f"Unknown command format: {cmd}")
                    continue

                # Handle dynamic file renaming
                if "C:/Data/" in scpi_command:
                    import re
                    match = re.search(r'["\'](C:/Data/[^"\']+)["\']', scpi_command)
                    if match:
                        original_path = match.group(1)
                        folder, filename = os.path.split(original_path)
                        filename_no_ext, file_ext = os.path.splitext(filename)
                        filename_dynamic = f"{filename_no_ext}_Run{self.run_counter:03d}{file_ext}"
                        folder_path = folder
                        os.makedirs(folder_path, exist_ok=True)
                        new_path = os.path.join(folder_path, filename_dynamic).replace("\\", "/")
                        scpi_command = scpi_command.replace(original_path, new_path)
                        self.text_edit.append(f"📁 Output path: {new_path}")
                    else:
                        self.text_edit.append("Could not parse file path from SCPI command.")

                # Route to correct instrument
                target_instr = None
                if instrument_key == "smbv":
                    target_instr = self.smb
                elif instrument_key == "fsw":
                    target_instr = self.fsw

                if not target_instr:
                    self.text_edit.append(f"No connection for instrument '{instrument_key}'")
                    continue

                # Execute the command
                # If it's a query (ends in '?'), use query
                if scpi_command.strip().endswith('?'):
                    response = target_instr.query(scpi_command)
                    self.text_edit.append(f"Query [{instrument_key}]: {scpi_command}")
                    self.text_edit.append(f"Response: {response.strip()}")
                else:
                    target_instr.write(scpi_command)
                    # Only call *OPC? after actual long operations (e.g., file saving or INIT)
                    if any(kw in scpi_command.upper() for kw in ["INIT", "MMEM", "WAV", "TRAC", "STOR"]):
                        response = target_instr.query("*OPC?")
                        self.text_edit.append(f" *OPC? → {response.strip()}")


        except Exception as e:
            self.text_edit.append(f" Unexpected error: {str(e)}")



    def connect_sfi(self):
        try:
            self.smb = RsInstrument(f'TCPIP::{self.sfi_ip.text()}::hislip0')
            self.text_edit.append(f"🔌 Connected to SFI: {self.smb.idn_string}")
        except Exception as e:
            self.text_edit.append(f" SFI Connection Error: {str(e)}")

    def disconnect_sfi(self):
        if self.smb:
            self.smb.close()
            self.text_edit.append("SFI Disconnected")

    def connect_fsw(self):
        try:
            ip = self.fsw_ip.text().strip()
            if not ip:
                self.text_edit.append(" FSW IP address is empty.")
                return

            rm = pyvisa.ResourceManager()
            resource = f'TCPIP0::{ip}::hislip0::INSTR'
            self.fsw = rm.open_resource(resource)
            self.fsw.timeout = 20000

            idn = self.fsw.query("*IDN?").strip()
            self.text_edit.append(f" Connected to FSW @ {ip} → {idn}")

        except Exception as e:
            self.text_edit.append(f" FSW Connection Error: {str(e)}")


    def disconnect_fsw(self):
        if self.fsw:
            self.fsw.close()
            self.text_edit.append("FSW Disconnected")

    def load_json(self):
        options = QFileDialog.Options()
        file_name, _ = QFileDialog.getOpenFileName(self, "Open JSON File", "", "JSON Files (*.json);;All Files (*)", options=options)

        if file_name:
            with open(file_name, 'r') as file:
                self.command_data = json.load(file)
                self.text_edit.setText(json.dumps(self.command_data, indent=4))


if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = SCPICommandExecutor()
    window.show()
    sys.exit(app.exec_())
