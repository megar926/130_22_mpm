import serial
import time
import sys

# ! /usr/bin/env python
# coding: utf-8
found = False
for i in range(64):
    try:
        port = "COM%d" % i
        ser = serial.Serial(port)
        ser.close()
        print ("Найден последовательный порт: ", port)
        found = True
    except serial.serialutil.SerialException:
        pass
if not found:
    print ("Последовательных портов не обнаружено")
#Open COM_PORT
ser = serial.Serial(port='COM7', baudrate=9600)
print (ser)
sel_reg = [0x00, 0x36, 0x41, 0x23]
data_in_adc = [0x00, 0x03, 0x4e, 0x23]
dac_ctrl = [0x00, 0x35, 0x41, 0x23]
data_in = [0x00, 0x01, 0x4E, 0x23]
r_test = ([0x00, 0xFF, 0x4F, 0x23])
data_out = [0x00, 0x02, 0x4E, 0x23]
data_in_sel = [0x00, 0x34, 0x41, 0x23]

dac_ctrl_read_reg = ([0xFF, 0x08, 0x00, 0x00])
#SEL REG commands
sel_reg_read_reg = ([0xFF, 0x3F, 0x00, 0x0F])
sel_reg_dac_pos = ([0x10, 0x00, 0x00, 0x00])
sel_reg_dac_neg = ([0x11, 0x00, 0x00, 0x00])
sel_reg_dac_gnd0 = ([0x12, 0x00, 0x00, 0x00])
sel_reg_dac_12v = ([0x13, 0x00, 0x00, 0x00])
sel_reg_dac_n12v = ([0x14, 0x00, 0x00, 0x00])
sel_reg_dac_pos_ = ([0x15, 0x00, 0x00, 0x00])# схема с внешним мультиметром
sel_reg_dac_neg_ = ([0x16, 0x00, 0x00, 0x00])# схема с внешним мультиметром
sel_reg_dac_gnd1 = ([0x17, 0x00, 0x00, 0x00])# схема с внешним мультиметром
sel_reg_dac_12v_ = ([0x18, 0x00, 0x00, 0x00])# схема с внешним мультиметром
sel_reg_dac_n12v_ = ([0x19, 0x00, 0x00, 0x00])# схема с внешним мультиметром
sel_reg_dac_pow = ([0xFA, 0xFF, 0x00, 0x00])# Включение потенциометра
sel_reg_dac_pob = ([0x1B, 0x00, 0x00, 0x00])# Включение потенциометра
sel_reg_dac_gnd = ([0x1C, 0x00, 0x00, 0x00])# Включение потенциометра
sel_reg_adc = ([0x00, 0x00, 0x00, 0x08])# Цап датчиков
sel_reg_vref = ([0x00, 0x00, 0x00, 0x09])# Цап датчиков
sel_reg_vip_d = ([0x00, 0x00, 0x00, 0x0A])# VIP D
sel_reg_vref_dac_10V = ([0x00, 0x00, 0x00, 0x0B])# 10 В с опорного источника питания
sel_reg_vref_2_5V = ([0x00, 0x00, 0x00, 0x0C])# 2.5 В с опорного источника питания

#sel_input_reg_0 = ([0x00, 0x01, 0x00, 0x00])# Enable Sel_input_reg
sel_input_reg_1 = ([0x01, 0x01, 0x00, 0x00])

def sel_input_func():
    sel_input_reg = ([0x00, 0x01, 0x00, 0x00])
    for x in range(0, 161):
        sel_input_reg[0] = x
        print(sel_input_reg)
        #time.sleep(1)
        write_to_mpm(data_in_sel, sel_input_reg)
        read_fr_mpm(data_in_sel)


data_in_adc_read_reg = ([0x71, 0x00, 0xF0, 0x0F])
data_in_adc_check_adc = ([0x01, 0x00, 0x10, 0x00])
data_in_read_reg = ([0xFF, 0xFF, 0xF1, 0x7F])#Can been clr dac reset
data_in_en = ([0x3C, 0xFF, 0xF1, 0x7F])

data_sel_reg_on = bytearray([0x10, 0x20, 0x00, 0x00])  #en3_1 ON
data_sel_reg_off = bytearray([0x00, 0x00, 0x00, 0x00])  #en3_1 OFF

data_ff = ([0xFF, 0xFF, 0xFF, 0xFF])
data_aa = ([0xAA, 0xAA, 0xAA, 0xAA])
data_55 = ([0x55, 0x55, 0x55, 0x55])
data_00 = [0x00, 0x00, 0x00, 0x00]
#data_00 = bytearray([0x00, 0x00, 0x00, 0x00])

#data_sel_reg = bytearray([0xF9, 0x3F, 0x00, 0x0F]) #check register
#data_sel_reg = bytearray([0x1A, 0x00, 0x00, 0x00]) #send data to pot pow
#data_sel_reg = bytearray([0x1B, 0x00, 0x00, 0x00]) #send data to pot pob
#data_sel_reg = bytearray([0x1C, 0x00, 0x00, 0x00]) #send data to pot gnd

cbe_write    = bytearray([0x07])
cbe_read     = bytearray([0x06])

def write_to_mpm(adr, dan):
    adr_int = bytearray(adr)
    dan_int = bytearray(dan)
    ser.write(adr_int)
    ser.write(dan_int)
    ser.write(cbe_write)
    print(dan_int)

def read_fr_mpm(adr):
    adr_int = bytearray(adr)
    ser.write(adr)
    ser.write(data_sel_reg_off)
    ser.write(cbe_read)
    in_hex = []
    for x in range(0, 4):
        #in_hex = []
        in_bin = ser.read()
        in_he = hex(int.from_bytes(in_bin, byteorder='little'))
        in_hex.insert(x, in_he)
        #print(in_hex)
    print (in_hex)
    return in_hex
#test register (write, then read and compare)
def reg_test(adr, dan):
    write_to_mpm(adr, dan)
    rd = read_fr_mpm(adr)
    for x in range (0, 4):
        if (hex(dan[x]) != rd[x]):
            print("ERROR  " + (hex(adr[3]))+ " " + (hex(adr[2])) + " " + (hex(adr[1])) + " " + (hex(adr[0])))
def check_start_regs ():
    read_fr_mpm(sel_reg)
    read_fr_mpm(r_test)
    read_fr_mpm(dac_ctrl)
    read_fr_mpm(data_in_adc)
    read_fr_mpm(data_in)

def check_adc (ch_sl, dev_sl):
    ch = int(ch_sl)
    dev = int(dev_sl)
    adc_reg_sl = []
    if (ch==0):
        adc_reg_ch = 0x01
        adc_reg_sl.insert(0, adc_reg_ch)
    elif (ch==1):
        adc_reg_ch = 0x11
        adc_reg_sl.insert(0, adc_reg_ch)
    elif (ch==2):
        adc_reg_ch = 0x21
        adc_reg_sl.insert(0, adc_reg_ch)
    elif (ch==3):
        adc_reg_ch = 0x31
        adc_reg_sl.insert(0, adc_reg_ch)

    if (dev == 0):
        adc_reg_dev = 0x10
        adc_reg_sl.insert(3, adc_reg_dev)
    elif (dev == 1):
        adc_reg_dev = 0x20
        adc_reg_sl.insert(3, adc_reg_dev)
    elif (dev == 2):
        adc_reg_dev = 0x40
        adc_reg_sl.insert(3, adc_reg_dev)
    elif (dev == 3):
        adc_reg_dev = 0x80
        adc_reg_sl.insert(3, adc_reg_dev)

    adc_reg_sl.insert(2, 0x00)
    adc_reg_sl.insert(1, 0x00)
    print((adc_reg_sl))
    write_to_mpm(data_in_adc, adc_reg_sl)

def dac_ctrl_check(dan, clr, pd):
    dac_reg_sl = []
    dac_reg_sl.insert(0, dan)
    if(clr==1):
        dac_reg_sl.insert(1, 0x04)
    if (pd == 1 and clr==1):
        dac_reg_sl[1] += 0x08
    elif(pd == 1 and clr==0):
        dac_reg_sl.insert(1, 0x00)
        dac_reg_sl[1] += 0x08
    dac_reg_sl.insert(2, 0x00)
    dac_reg_sl.insert(3, 0x00)
    data_sel_reg = bytearray(dac_reg_sl)
    print(data_sel_reg)
    write_to_mpm(dac_ctrl, data_sel_reg)

   # dac_reg_sl.reverse()
   # in_he.reverse()

#Main program

#for x in range(0, 1):
#reg_test(dac_ctrl, dac_ctrl_read_reg)
#    reg_test(dac_ctrl, data_00)
#   reg_test(sel_reg, sel_reg_read_reg)
#    reg_test(sel_reg, data_00)
#reg_test(data_in_adc, data_in_adc_read_reg)
#   reg_test(data_in_adc, data_00)
 #   reg_test(data_in_adc, data_in_adc_check_adc)
#    reg_test(data_in_adc, data_00)
#reg_test(data_in, data_in_en)
#reg_test(data_in, data_in_en)
#reg_test(data_in, data_in_en)

#reg_test(sel_reg, sel_reg_dac_pos)
#reg_test(sel_reg, sel_reg_dac_neg)
#reg_test(sel_reg, sel_reg_dac_gnd0)
#reg_test(sel_reg, sel_reg_dac_12v)
#reg_test(sel_reg, sel_reg_dac_n12v)
#reg_test(sel_reg, sel_reg_dac_pos_)
#reg_test(sel_reg, sel_reg_dac_neg_)
#reg_test(sel_reg, sel_reg_dac_gnd1)
#reg_test(sel_reg, sel_reg_dac_12v_)
#reg_test(sel_reg, sel_reg_dac_n12v_)
#reg_test(sel_reg, sel_reg_dac_pow)
#reg_test(sel_reg, sel_reg_dac_pob)
#reg_test(sel_reg, sel_reg_dac_gnd)

#reg_test(sel_reg, sel_reg_adc)
#reg_test(sel_reg, sel_reg_vref)
#reg_test(sel_reg, sel_reg_vip_d )
#reg_test(sel_reg, sel_reg_vref_dac_10V)
#reg_test(sel_reg, sel_reg_vref_2_5V)

sel_input_func()
read_fr_mpm(data_in_sel)
write_to_mpm(data_in_sel, sel_input_reg_1)
read_fr_mpm(data_in_sel)
#for x in range (0, 3):
#check_adc(0, 3)
#read_fr_mpm(data_out)