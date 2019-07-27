// CONTROLLER REGISTERS
`define IN_1                     16'h1300
`define IN_2                     16'h1310
`define SENS                     16'h1320
`define C_IMSH                   16'h1330
`define R_ERR                    16'hF000
`define R_TEST                   16'hFFF0
`define DATA_IN                  16'hE010
`define DATA_OUT                 16'hE020
`define DATA_IN_ADC              16'hE030
`define SEL_REG                  16'h1360
`define DAC_CTRL                 16'h1350
`define DATA_IN_SEL              16'h1340
`define RELAY_CTRL               16'h1370

// DATA_IN_SEL (sel_input.v)
`define CH_IN_SEL                [7:0]
`define En                       [8]
`define ACTIVE                   [9]
//delay time  
`define DELAY_MKS                 10
//DELAY between chanel switch 
`define DELAY_MKS_CH              10
`define DELAY_MKS_CONN4WIRE       1
`define DELAY_MKS_CONNMULT        1

// DATA_IN_ADC 
`define En_ADC                   [0]
`define Dev_ADC                  [28:20]
`define CH_SEL_ADC               [6:4]

// SEL_REG (sel_reg.v)
`define A3_MUX                   [3:0]
`define A6_MUX                   [26:24]
`define En_A3_MUX                [4]
`define En_A6_MUX                [27]
`define POT_DAN_OUT              [13:5]

//RELAY CTRL (relay_reg.v)
`define ConnMult                 [0]
`define Conn4wire                [1]

//DAC_CTRL (dac_ctrl.v)
`define DAN_DAC_1                [9:0]
`define CLR_DAC_1                [10]
`define PD_DAC                   [11]

//SENS
`define SET1_CHECK_A             [8]
`define SET2_CHECK_A             [9]
`define SET3_CHECK_A             [10]
`define SET4_CHECK_A             [11]
`define SET1_CHECK_B             [12]
`define SET2_CHECK_B             [13]
`define SET3_CHECK_B             [14]
`define SET4_CHECK_B             [15]
`define SET1_CHECK_C             [16]
`define SET2_CHECK_C             [17]
`define SET3_CHECK_C             [18]
`define SET4_CHECK_C             [19]
`define SET1_CHECK_D             [20]
`define SET2_CHECK_D             [21]
`define SET3_CHECK_D             [22]
`define SET4_CHECK_D             [23]
`define ADC_EN                   [24]
`define SET_A_B_C                [25] 
`define A4_0                     [26]
`define A4_1                     [27]
`define A4_2                     [28]
`define A4_3                     [29]
`define EN_RB                    [30]