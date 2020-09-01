#include <eekernel.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <malloc.h>
#include <math.h>
#include <libdev.h>
#include <eeregs.h>
#include <libgraph.h>
#include <libdma.h>
#include <libpkt.h>
#include <libvu0.h>
#include <sif.h>
#include <sifdev.h>
#include <sifrpc.h>
#include <libpad.h>

#include "sio2man.h"

int SifLoadModuleFromBuffer(const char* Buffer, const unsigned int Size)
{
    sceSifInitRpc(0);
    sceSifInitIopHeap();

    sceSifDmaData dmaData;

    void* iopAddress = NULL;

    iopAddress = sceSifAllocIopHeap(Size);

    dmaData.data = (unsigned int) Buffer;
    dmaData.addr = (unsigned int) iopAddress;
    dmaData.size = Size;
    dmaData.mode = 0;

    sceSifSetDma(&dmaData, 1);

    int loadResult = sceSifLoadModuleBuffer(iopAddress, 0, NULL);
    
    if (loadResult < 0) 
    {
        printf("Sio2Man module load failed...\n");
        printf("ErrCode: %x\n", loadResult);
        return -1;
    }

    sceSifFreeIopHeap(iopAddress);

    return 0;
}

int main()
{
    int loadModuleReturn = SifLoadModuleFromBuffer(module_sio2man, module_sio2man_length);
    printf("loadModuleReturn: %d\n", loadModuleReturn);

    while (1);

    return 0;
}
