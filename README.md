UART-Receiver
=============

Circuit Design to take 16 bit serial data as input and output it in parallel form

This project was part of the course `EC-104 Digital Design` supervised by <a href="http://www.iitr.ac.in/departments/ECE/pages/People+Faculty+samanfec.html">Prof. Sanjeev Manhas</a> at <a href="http://www.iitr.ac.in">IIT Roorkee.</a>

Universal Asynchronous Receiver Transmitter converts serial bytes it receives into parallel data for outbound transmission. 

Firstly we need to synchronize with transmitter using the falling edge of the start bit. Then, samples the input data line at a clock rate that is, normally a multiple of baud rate, typically 16 times the baud rate. Lastly, removes the start and stop bits, optionally calculates and checks the parity bit.

Present the received data value in parallel form.
