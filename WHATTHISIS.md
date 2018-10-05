# Processing-Portal-Turret
This is an app written in processing java that detects faces, calculates where it is in relation to the camera, scales it so that when written to a 
servo it accurately follows the face, and it also has the voice of the turrets from Portal 2. It also sends the face position data over serial
so that it can be recieved by some microprocessor(in my case an arduino uno, but soon I hope to rewrite the code for an atmega328p chip without
a bootloader) and written to a pan and tilt servo.
