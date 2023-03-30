# Cache-Memory-Controller_project
This repo consists of my work on designing a simple efficient cache mem controller which can control the data between cache and cpu.
The cache controller is a hardware block responsible for managing the cache memory, in a way that is largely invisible to the program. It automatically writes code or data from main memory into the cache.
The project is created using 45nm cmos technology which made it possible to reduce the overall area corresponding to reduce in overall power.
Cache hit ratio is a measurement of how many content requests a cache is able to fill successfully, compared to how many requests it receives/
In this work I made assure to have high hit ratio by reducing the cache miss penality. When a cache miss occurs then the controller doesn't fetch instructions from the main memory which takes more time.
Instead it reaches to the nearest memory locations to fetch the instructions.
