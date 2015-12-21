This repo contains the script to convert PRUSS binary fimware to ELF format.

The script takes 2 inputs per PRU core
1) the binary firmware file
2) an ELF file containing the .resource_table data section.

It produces one output ELF file per PRU core.

The output ELF file is madeup of the binary firmware contents
in the .text section and the resource table in the .resource_table
section. Any extra sections contained in the input ELF file will be ignored.

Usage: Update the macros in the script to point to the appropriate
files in your filesystem and run the script without any arguments.

Requirements: objcopy with elf32-little support.
