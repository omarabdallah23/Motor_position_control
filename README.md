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
excessive overshoot so I assumed a settling time of 40ms and an overshoot of 16%.
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
The gain crossover frequency of the plant is approximately 5Hz so  a sampling time of 0.001s is significantly faster than the dynamics of the plant meaning that the sampled output of the system captures the full behavior of the system and that no significant inter-sample behavior is missed.

The open-loop transfer function =

![dga](https://github.com/omarabdallah23/Motor_position_control/assets/143711494/2b6bce8a-80d7-4243-83f8-cf71795c4948)

You can tranform it from the s-domain to the z-domain using c2d command so the open-loop tranfer function in z-domain becomes = 

![ga](https://github.com/omarabdallah23/Motor_position_control/assets/143711494/c5bae489-c52f-4839-b842-895e2e7d01f7)

We can observe that there is a pole and a zero that practically cancel each other. Cancelling the pole and zero will reduce the order of the tranfer function and makes the mathematical calculations easier for MATLAB.

![discrete_closed-loop_response](https://github.com/omarabdallah23/Motor_position_control/assets/143711494/cf53f8ad-a45c-47bd-bb9e-db0a536b5d99)

In the above picture, we can see the open-loop transfer function after zero-pole cancellation. We can also see the closed-loop response with C(z) = 1.
We will employ a root-locus design methodolgy to generate a digital controller.

The root locus of the open-loop transfer function:

![adhf](https://github.com/omarabdallah23/Motor_position_control/assets/143711494/5690a5c9-a7bc-43c6-b787-b0f30e5bf02b)

I added an integrator to delete the effect of a constant disturbance in steady state. You can add an integrator through the **control system designer** tool under the **compensator editor** window. Right-click on the **designer** section, press **Add pole/zero** then **integrator**. A pole is added at 1 on the root locus. By default, the root locus includes the unit circle and in discrete-time systems the system is stable as long as the closed-loop poles in inside the unit circle, however from the picture below, we can see that adding a pole at 1, the root locus has three poles near 1 and the root locus moved outside from the unit circle (dashed line).

![asdg](https://github.com/omarabdallah23/Motor_position_control/assets/143711494/46cbb9c8-5dee-420d-b365-8d3b6a73eebb)

I added a zero at 0.95 to cancel one of the poles and pull the rootlocus back into the unit circle. You can add the zero the same way i added the integrator but choose **Real zero** and write the location of the zero in the **Location** cell. The addition of an inegrator helped us with distrurbance rejection but the other requirments are not addresed yet. To identify the region of the complex plane where we need to place the closed loops to meet our requirments, right-click on the root locus, choose **design requirments** then set the overshoot to less than 16% then reapet the process but choose the settling time to be 0.04s. The root locus becomes as the pic below:

![Root_locus_after_adding_overshoot_and_settling_time_requirments](https://github.com/omarabdallah23/Motor_position_control/assets/143711494/ed9994b5-93a2-4715-8dd3-8aa154b29877)

From the above figure, we can see that the two dominant branches do not pass the required region so we need to add poles/zeros to the rootlocus to bend it to the desired region. I cancelled the zero at -0.98 by adding a pole at -0.98 because this zero will add overshoot to the step-response. However the addition of this pole will make the root locus go out from the unit circle so i added two zeros to pull the rootlocus back in however this time i used a graphical tuning approach instead of adding zeros directly. Select o from the **ROOT LOCUS EDITOR** at the top of the **Control system deigner** window then click on the real axis to place the zero then repeat for the second zero. You can drag the zeros by holding left-click to view the effects of different locations. After trial and error, the value of zeros = 0.8. In order to make the controller more casual i added a pole using the graphical tuning approach. After trial and error, the value of the pole  = 0.6. The root locus becomes as follows:

![xvmgh](https://github.com/omarabdallah23/Motor_position_control/assets/143711494/c142b405-63fc-45d7-8643-35779d1ea1f8)

You must choose a gain to move the closed-loop pole location along the rootlocus in order to meet our requirments. I employed some trial and error and to assist me in this regard, I opened a plot for the closed-loop step response so that we can observe the effect of the gain changes on the actual step response. Move to the **IOTransfer_r2y:step** tab. click on the **New Plot** menu and under **Create New Plot**, choose **New Step**. From **Select Responses to Plot** menu choose **IOTransfer_r2y**. Then click on **Plot**. The closed-loop step response will then appear in the figure. The closed-loop response meets the settling-time requirment but not the overshoot requirment. Right-click on the closed-loop response, choose **Design requirments** and the specify the overshoot to be 16% and setlling time to be 0.04s. By a graphical tuning approach, grab one of the pink boxes on the root locus plot by clicking on it, then drag the box along the locus. You can see that the loop gain changes and the effect of the change can be seen on the closed-loop response. By trial and error, a loop gain meets the requirments.  
## SIMULINK model:
I simulated the following equations on SIMULINK:

d^2theta/dt^2 = (1/J) * (Kt * i - b * dtheta/dt)

di/dt = (1/L) * (-R * i + V - Kb * dtheta/dt)

![asgdadfh](https://github.com/omarabdallah23/Motor_position_control/assets/143711494/ea3b190d-797f-42e2-ab10-86216bf7563f)

You can also build this model in SIMSCAPE using the physical modeling blocks. The blocks in the Simscape library represent actual physical components; therefore, complex multi-domain models can be built without the need to build mathematical equations from physical principles as was done above by applying Newton's laws and Kirchoff's laws.

![gnd](https://github.com/omarabdallah23/Motor_position_control/assets/143711494/359b97a1-0380-417f-a097-2ee35c59d13f)

The open-loop response:

![open-loop_response_SIMULINK](https://github.com/omarabdallah23/Motor_position_control/assets/143711494/7daab8e6-be41-446d-8ffb-f2a1afbb4548)

The closed- loop response (without a constant disturbance):

![adjgcs](https://github.com/omarabdallah23/Motor_position_control/assets/143711494/749eb8ec-670d-4f58-b022-00f75f88109b)

The zero-order hold between the controller and the plant transforms discrete-time signal into a step-wise constant continous signal. The zero-order hold at the output of the planr is used to take discrete samples of the output signal.

The closed- loop response (with a constant disturbance at 0.03s):

![dnxvxvsd](https://github.com/omarabdallah23/Motor_position_control/assets/143711494/19d6df3d-c8ee-41e5-a22c-2ac02a31f200)

We can see that there is a slight bump at 0.03s but the controller is able to reject its effect and the steady-state error remains zero as required.
