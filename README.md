# 🔐 Secure 8-bit ALU with Hardware Encryption on FPGA  
### Developed by **Akhilesh Marimuthu S.** & **Lakkshaya E.**

#### 🎓 Department of Electronics & Communication Engineering  
#### 🏫 Chennai Institute of Technology  
#### ⚙️ Vivado 2018.2 | Verilog HDL | Digilent Arty S7-50 FPGA (XC7S50CSGA324-1)

---

## 📌 Project Overview

This project implements a **Secure 8-bit Arithmetic Logic Unit (ALU)** with **built-in hardware encryption**, implemented and tested on the **Arty S7-50 FPGA development board**.

The ALU performs multiple arithmetic and logical operations using switch inputs and **automatically encrypts the final output** using either:
- **S-Box Substitution Cipher (block-based substitution)**
- **XOR One-Time-Pad encryption**

The goal is to ensure that the output is **always encrypted** before leaving the ALU, making it resistant to direct observation attacks or reverse-engineering.

---

## ⚙️ Features & Supported Operations

| Opcode (Buttons) | Operation | Description |
|------------------|-----------|-------------|
| `00` | ADD (A + B) | Addition of inputs |
| `01` | SUB (A - B) | Subtraction |
| `10` | XOR Logic | Bitwise XOR |
| `11` | S-Box substitution | Non-linear encrypted output |
| `1000` | Pass A | Output = A |
| `1001` | Pass B | Output = B |
| `1010` | Left Shift | A << 1 |
| `1011` | Right Shift | A >> 1 |
| `1100` | Increment | A + 1 |
| `1101` | Decrement | A - 1 |

🔐 **Encryption:** Every operation output is fed into an encryption module (OTP XOR & S-Box block cipher).

---

## 🧠 Inputs & Outputs

| FPGA Input | Description |
|------------|-------------|
| `SW0–SW3` | 4-bit input operand A |
| Constant B | Fixed internally as **5** |
| `BTN0–BTN1` | Select operation |
| `LED0–LED3` | Displays encrypted 4-bit output |

---

## 🧪 Testing on FPGA

### **How to test**
| Step | Action |
|------|--------|
| 1 | Set operand A using switches SW0–SW3 |
| 2 | Choose ALU operation using buttons |
| 3 | Observe encrypted output on LEDs 0-3 |
| 4 | Change switches & compare real vs encrypted values |

📍 **Note:** LED output will not match actual arithmetic value because it is encrypted.

Example:
