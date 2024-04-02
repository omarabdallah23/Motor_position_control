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

## Analysis:
