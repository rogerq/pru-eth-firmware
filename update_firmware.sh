#!/bin/sh

PRU0_RESOURCE_TABLE=/work/pru-software-support-package/examples/am572x/PRU0_emac_rsc/gen/PRU0_emac_rsc.out
PRU1_RESOURCE_TABLE=/work/pru-software-support-package/examples/am572x/PRU1_emac_rsc/gen/PRU1_emac_rsc.out
NULL_RSC=/work/pru-software-support-package/examples/am572x/null_rsc/gen/null_rsc.out
#FIRMWARE0=/work/icss_firmware/ti_internal/protocols/ethernet_switch/firmware/test.bin
FIRMWARE0=/work/icss_firmware/ti_internal/protocols/ethernet_switch/firmware/Micro_Scheduler_PRU0.bin
FIRMWARE1=/work/icss_firmware/ti_internal/protocols/ethernet_switch/firmware/Micro_Scheduler_PRU1.bin
OUT0=prueth-pru0-firmware.elf
OUT1=prueth-pru1-firmware.elf

rm -f *.bin *.out *.elf *.tmp

#---PRU0---
#extract resource table from PRU0_RESOURCE_TABLE into rsc0.bin
objcopy -I elf32-little --dump-section .resource_table=rsc0.bin $PRU0_RESOURCE_TABLE
#combine rsc.bin as .resource_table and $FIRMWARE0 as .text into ELF $OUT0.tmp
objcopy -I binary -O elf32-little --rename-section .data=.text --add-section .resource_table=rsc0.bin $FIRMWARE0 $OUT0.tmp
#mark .text as executable, loadable and allocatable
objcopy -I elf32-little --set-section-flags .text=code,alloc,load $OUT0.tmp

#---PRU1---
#extract resource table from PRU1_RESOURCE_TABLE into null_rsc1.bin
objcopy -I elf32-little --dump-section .resource_table=rsc1.bin $PRU1_RESOURCE_TABLE
#combine rsc.bin as .resource_table and $FIRMWARE1 as .text into ELF $OUT1.tmp
objcopy -I binary -O elf32-little --rename-section .data=.text --add-section .resource_table=rsc1.bin $FIRMWARE1 $OUT1.tmp
#mark .text as executable, loadable and allocatable
objcopy -I elf32-little --set-section-flags .text=code,alloc,load $OUT1.tmp

#add program headers. -n to disable page alignment of sections.
ld -n --accept-unknown-input-arch $OUT0.tmp -T linker_pru0.txt -o $OUT0 -M --oformat=elf32-little
ld -n --accept-unknown-input-arch $OUT1.tmp -T linker_pru1.txt -o $OUT1 -M --oformat=elf32-little

sudo cp $OUT0 $OUT1 /srv/nfsroot/lib/firmware/
