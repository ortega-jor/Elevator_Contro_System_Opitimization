# Elevator Control System Optimization

This repository contains the MATLAB implementation and simulation results of a two-elevator control system developed as a final project for the Control System Engineering course (EECE 5659).

---

## Project Overview

The main objective of this project is to design, implement, and compare multiple control strategies for the operation and coordination of two elevators in a multi-floor building. The elevator control algorithms aim to reduce total service time, minimize energy use, and ensure balanced request handling between elevators.

---

## Controllers Implemented

### 🔹 First Call Controller (FCC)
- Simultaneous two-elevator operation using `parfeval`
- Assigns requests based on their order of arrival
- Implements locking and parallel pools to avoid conflict

### 🔹 Closest Call Controller (CCC)
- Assigns each request to the physically closest elevator
- Operates sequentially (only one elevator active at a time)

### 🔹 Optimized Multi-Elevator Controller (OMEC)
- Most advanced solution
- Groups and fulfills multiple requests in the same direction
- Maintains parallel operation with worker pools and dynamic request filtering

---

## Key Features

- Real-time simulation of elevator behavior using MATLAB
- Shared `.mat` file for dynamic request handling (`requests_queue`)
- Elevator movement logic with pickup/drop-off delays
- Output log written to text files for real-time monitoring
- `parfeval` used for parallel execution in FCC and OMEC

---

## Simulation Results

| Metric                        | CCC     | FCC     | OMEC    |
|------------------------------|---------|---------|---------|
| Total Time (s)               | 226.9   | 126.7   | 90.5    |
| Total Requests Fulfilled     | 12      | 12      | 12      |
| Total Floors Travelled       | 77      | 83      | 38      |
| Elevator 1 Requests          | 8       | 6       | 6       |
| Elevator 2 Requests          | 4       | 6       | 6       |

---

## Author
**Jorge Ortega Camazón**  
Bachelor’s Degree in Industrial Electronics and Automation Engineering  
Final Project: Elevator Control System Optimization for a Two-Elevator Building
