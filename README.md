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
T = Kt*i
e = Kb*dtheta/dt
