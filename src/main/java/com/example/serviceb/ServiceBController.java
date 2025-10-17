package com.example.serviceb;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ServiceBController {

   // The amount of work is now controlled by an iteration count.
   // Defaults to 50,000 if not set.
   @Value("${WORK_ITERATIONS:50000}")
   private int workIterations;

   @GetMapping("/data")
   public String getDataWithCpuWork() {
       // This loop performs a simple calculation many times to consume CPU.
       // When the container is throttled, this loop will take much longer to complete.
       for (int i = 0; i < workIterations; i++) {
           Math.sqrt(i); // A simple, non-trivial calculation
       }
      
       return String.format("Success! (after %d work iterations)", workIterations);
   }
}
