# 🔐 Secure 8-bit ALU with Hardware Encryption on FPGA
### **Arty S7-50 (XC7S50CSGA324-1) — Verilog | Vivado 2018.2**

---

## 📌 Project Overview
This project implements a **Secure 8-bit Arithmetic Logic Unit (ALU)** on the **Digilent Arty S7-50 FPGA board**.  
The ALU performs arithmetic and logical operations using switch inputs and **automatically encrypts the output** using an **S-Box based substitution cipher** implemented in hardware.

This demonstrates:
- FPGA-based computation
- Hardware cryptography integration
- Real-time output observation through LEDs

---

## 🧠 Features

| Category | Details |
|---------|---------|
| **FPGA Board** | Digilent Arty S7-50 (Spartan-7) XC7S50 |
| **Development Tool** | Xilinx Vivado 2018.2 |
| **HDL Language** | Verilog |
| **ALU Operations** | ADD, SUB, XOR, Left Shift, Right Shift, Increment, Decrement, Pass A, Pass B |
| **Encryption Method** | S-Box substitution cipher |
| **Operand A Input** | SW0–SW3 |
| **Operand B Input** | Constant `5` |
| **Operation Select** | BTN0–BTN1 |
| **Output** | Encrypted 4-bit result displayed on LEDs LED2–LED5 |

---

## 🎛 I/O Controls

### **Switches — Input A**
| SW | Binary | Value |
|----|--------|-------|
| SW0–SW3 | b3 b2 b1 b0 | 0–15 |

### **Buttons — Select ALU Operation**
| BTN1 BTN0 | Operation |
|-----------|-----------|
| 00 | ADD |
| 01 | SUB |
| 10 | XOR |
| 11 | S-BOX transform |

### **LEDs — Output Display**
| LED | Description |
|-----|-------------|
| LED2–LED5 | Encrypted result `[3:0]` |
| LED1 & LED0 (board-default) | Not used for ALU result |

---

## 🧮 Example Verification Table

| A (Switch Input) | Operation | Buttons | Result | Encrypted Using S-Box | LED Output |
|------------------|-----------|---------|---------|------------------------|-------------|
| 0100 (4) | ADD | 00 | 4+5=9 | SBOX(9)=E | 1110 |
| 1010 (10) | SUB | 01 | 10-5=5 | SBOX(5)=0 | 0000 |
| 0111 (7) | XOR | 10 | 7⊕5=2 | SBOX(2)=6 | 0110 |
| 0011 (3) | S-BOX | 11 | SBOX(3)=B | B=1011 | 1011 |



---

## 🧪 Testing Procedure on FPGA

1. Connect the **Arty S7-50 board** and power ON.
2. Load the **generated bitstream (.bit)** through Vivado Hardware Manager.
3. Set input value using **SW0–SW3**.
4. Select ALU operation using **BTN0–BTN1**.
5. Observe encrypted output on **LED2–LED5**.

Example testing:
SW = 0100 (A = 4)
BTN1 BTN0 = 00 (ADD)
Result = SBOX(4+5 = 9) ⇒ E (1110) → LEDs: ON ON ON OFF


---

## 🚀 Future Improvements
- Pipeline enhancement for higher performance
- UART serial I/O for PC terminal display
- AES-style block encryption support
- Low-power optimization

---

## 👤 Author

**Akhilesh Marimuthu**  
B.E Electronics & Communication Engineering  
Chennai Institute of Technology  

📧 Email: akhileshmarimuthu31@gmail.com  
🔗 GitHub: https://github.com/akhilesh-marimuthu31  

---

### ⭐ If you found this project helpful, please star the repository!  

---

## 📂 File Structure

