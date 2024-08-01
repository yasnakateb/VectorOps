#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xil_io.h"
#include "xscutimer.h"

#define VECTOR_SIZE 10
#define INST_SIZE 4

#define OP_SUM 0
#define OP_SUB 1
#define OP_MUL 2
#define OP_OR 3

#define NUM_ALU 4
#define DEFAULT_VALUE 999

#define ADDER_b 0x43C00000
#define REG_0_o 0x0
#define REG_1_o 0x4
#define REG_2_o 0x8
#define REG_3_o 0xC
#define REG_4_o 0x10
#define REG_5_o 0x14
#define REG_6_o 0x18
#define REG_7_o 0x1C
#define REG_8_o 0x20
#define REG_9_o 0x24
#define REG_10_o 0x28
#define REG_11_o 0x2C
#define REG_12_o 0x30
#define REG_13_o 0x34
#define REG_14_o 0x38
#define REG_15_o 0x3C

#define TIMER_LOAD_VALUE 0xFFFFFFFF

int A[4][4] = {
    {1, 2, 3, 4}, 
    {5, 6, 7, 8}, 
    {1, 2, 3, 4}, 
    {2, 4, 8, 14}
};

int B[4][4] = {
    {1, 2, 3, 4}, 
    {1, 4, 2, 7}, 
    {1, 2, 3, 4}, 
    {1, 1, 3, 1}
};

int C[4][4] = {
    {0, 0, 0, 0}, 
    {0, 0, 0, 0}, 
    {0, 0, 0, 0}, 
    {0, 0, 0, 0}
};

int OP[4] = {OP_SUM, OP_SUB, OP_MUL, OP_OR};

void vector_ops(int A[][NUM_ALU], int B[][NUM_ALU], int OP[INST_SIZE]) {
    for (int i = 0; i < INST_SIZE; i++) {
        for (int j = 0; j < NUM_ALU; j++) {
            switch (OP[i]) {
                case OP_SUM:
                    C[i][j] = A[i][j] + B[i][j];
                    break;
                case OP_SUB:
                    C[i][j] = A[i][j] - B[i][j];
                    break;
                case OP_MUL:
                    C[i][j] = A[i][j] * B[i][j];
                    break;
                case OP_OR:
                    C[i][j] = A[i][j] | B[i][j];
                    break;
            }
            printf("A = %d, B = %d, C = %d\n", A[i][j], B[i][j], C[i][j]);
        }
    }
}

int main() {
    init_platform();

    // Timer Setup for problem using only Software
    XScuTimer TimerInstancePtr1; /* Timer Data Structure (global) */
    XScuTimer_Config TimerConfigPtr1;
    TimerConfigPtr1 = *XScuTimer_LookupConfig(XPAR_PS7_SCUTIMER_0_DEVICE_ID);
    XScuTimer_CfgInitialize(&TimerInstancePtr1, &TimerConfigPtr1, TimerConfigPtr1.BaseAddr);

    // Timer Setup for Problem with Software and Hardware
    XScuTimer TimerInstancePtr2; /* Timer Data Structure (global) */
    XScuTimer_Config TimerConfigPtr2;
    TimerConfigPtr2 = *XScuTimer_LookupConfig(XPAR_PS7_SCUTIMER_0_DEVICE_ID);
    XScuTimer_CfgInitialize(&TimerInstancePtr2, &TimerConfigPtr2, TimerConfigPtr2.BaseAddr);
    XScuTimer_LoadTimer(&TimerInstancePtr2, TIMER_LOAD_VALUE);

    // Software part 
    int A1[INST_SIZE][NUM_ALU] = {
        {3, 2, 3, 4}, 
        {5, 6, 7, 8}, 
        {1, 2, 3, 4}, 
        {2, 4, 8, 14}
    };
    
    int B1[INST_SIZE][NUM_ALU] = {
        {1, 2, 3, 4}, 
        {1, 4, 2, 7}, 
        {1, 2, 3, 4}, 
        {1, 1, 3, 1}
    };
    
    int C1[INST_SIZE][NUM_ALU] = {
        {0, 0, 0, 0}, 
        {0, 0, 0, 0}, 
        {0, 0, 0, 0}, 
        {0, 0, 0, 0}
    };

    int OP1[4] = {OP_SUM, OP_SUB, OP_MUL, OP_OR};

    printf("Problem using only Software\n\r");

    u32 CntValue1; // Value read from the timer (global)

    XScuTimer_LoadTimer(&TimerInstancePtr1, TIMER_LOAD_VALUE);
    XScuTimer_RestartTimer(&TimerInstancePtr1);
    XScuTimer_Start(&TimerInstancePtr1);

    vector_ops(A1, B1, OP1);

    CntValue1 = XScuTimer_GetCounterValue(&TimerInstancePtr1);
    xil_printf("Time measured (Only Software): %d clock cycles\n\r", TIMER_LOAD_VALUE - CntValue1);

    // Hardware and Software part

    int reg_op_wdata = 0;
    int res_addr = 0;
    int reg_a_wdata = DEFAULT_VALUE;
    int reg_b_wdata = DEFAULT_VALUE;

    u32 reg_res1_rdata = DEFAULT_VALUE;
    u32 reg_res2_rdata = DEFAULT_VALUE;
    u32 reg_res3_rdata = DEFAULT_VALUE;
    u32 reg_res4_rdata = DEFAULT_VALUE;

    u32 CntValue2; // Value read from the timer (global)

    XScuTimer_RestartTimer(&TimerInstancePtr2);
    XScuTimer_Start(&TimerInstancePtr2);

    for (int i = 0; i < INST_SIZE; i++) {
        reg_op_wdata = OP[i];
        Xil_Out32(ADDER_b + REG_8_o, reg_op_wdata);
        res_addr = 0;
        for (int j = 0; j < NUM_ALU; j++) {
            reg_a_wdata = A1[i][j];
            Xil_Out32(ADDER_b + res_addr * 4, reg_a_wdata);
            res_addr++;
            reg_b_wdata = B1[i][j];
            Xil_Out32(ADDER_b + res_addr * 4, reg_b_wdata);
            res_addr++;
        }

        reg_res1_rdata = Xil_In32(ADDER_b + REG_9_o);
        reg_res2_rdata = Xil_In32(ADDER_b + REG_10_o);
        reg_res3_rdata = Xil_In32(ADDER_b + REG_11_o);
        reg_res4_rdata = Xil_In32(ADDER_b + REG_12_o);

        C1[i][0] = reg_res1_rdata;
        C1[i][1] = reg_res2_rdata;
        C1[i][2] = reg_res3_rdata;
        C1[i][3] = reg_res4_rdata;
    }

    printf("Problem using with custom IP\n\r");
    for (int i = 0; i < INST_SIZE; i++) {
        for (int j = 0; j < NUM_ALU; j++) {
            printf("A = %d, B = %d, C = %d\n", A1[i][j], B1[i][j], C1[i][j]);
        }
    }

    CntValue2 = XScuTimer_GetCounterValue(&TimerInstancePtr2);
    xil_printf("Time measured (Hardware and Software): %d clock cycles\n\r", TIMER_LOAD_VALUE - CntValue2);

    return 0;
}
