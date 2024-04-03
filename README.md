# Motor_position_control
## List of contents:
1. Modeling
2. Analysis
3. Digital controller
4. SIMULINK modeling
## Modeling:
A common actuator in control systems is the DC motor. It directly provides rotary motion and, coupled with wheels or drums and cables, can provide translational motion.
Assume the following values for the physical parameters:
1. Moment of inertia of the rotor (J) = 3.2284E-6 kg.m^2
2. Motor viscous friction constant (b) = 3.5077E-6 N.m.s
3. Electromotive force constant (Kt) = 0.0274 V/rad/sec
4. Motor torque constant (Kb) = 0.0274 N.m/Amp
5. Electric resistance (R) = 4 Ohm
6. Electric inductance (L) = 2.75E-6H
The input is the voltage (V) while the output is the position (theta)
### System equations:
T = Kt * i

e = Kb * (dtheta/dt)

Back emf and motor torque constants are equal so Kt = Kb = K

From Newton's 2nd law -> J * (d^2theta/dt^2) + b * (dtheta/dt) = K * i

From Kirchoff's law -> L * (di/dt) + R * i = V - K * (dtheta/dt)

Applying laplace's transform:

s * (J * s + b) * theta(s) = K * I(s) -> equ(1)

(L * s + R) * I(s) = V(s) - K * s * theta(s) -> equ(2)

from equ(1) and equ(2):

theta(s) / V(s) = K / s * ((J * s + b)(L * s + R) + K^2)
### Design requirments:
We want the position of the DC motor to be very precise even when there is a constant disturbance so the steady state error must be zero. We also want the motor to reach the desired position very fast and without
excessive overshoot so we can assume a settling time of 40ms and an overshoot of 16%.
## Analysis:
### Open-loop response:
![open-loop_response](https://github.com/omarabdallah23/Motor_position_control/assets/143711494/07e9b145-5760-4e34-bbd3-946429cccd75)

We can see that when 1 volt is applied to the uncompensated system the system becomes unstable. One of the poles of the open-loop transfer function is on the imaginary axis while the other two are on the left -half of the s-complex plane. The pole of the imaginary axis indicates that the open-loop response is bounded, however, it can grow unbounded when an input is given.
### Closed-loop response:
![closed_loop_response](https://github.com/omarabdallah23/Motor_position_control/assets/143711494/3a522440-95bc-4206-9815-19f0bdc09937)

By creating a feedback and just with a controller of gain = 1, we can see the system becomes stable. There is no steady-state error and the overshoot is less than 16%, however, the settling time requirmnet of 40 ms is not met.

![poles_and_zeros_map](https://github.com/omarabdallah23/Motor_position_control/assets/143711494/a1404fc1-4d5a-4539-a745-d6fa259de240)

Since the real pole is so much faster than the complex conjugate poles its effect on the dynamic response of the system will be minimal
There are different approaches to design controllers but in this project i will use a discrete-controller in order to meet the settling-time requirment and a zero steady-state error even with the presence of a step disturbance.
## Digital controller:
