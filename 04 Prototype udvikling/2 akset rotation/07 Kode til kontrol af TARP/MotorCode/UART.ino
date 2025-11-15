//H123 Slettes til fordel for serial comms
void readFromPC() {
  // Variables to hold the parsed data
  int motorID = -1;  // Default to -1 (error/no motor selected)
  int angle = 0;     // angle input
  String data = client.readStringUntil('\n');

  // Check if the received string is NOT empty (meaning there is a message)
  if (!data.isEmpty()) {

    data.trim();  // Clean up the string (removes newline/carriage return and leading/trailing spaces)

    // 1. Find the position of the separator (space)
    int separatorIndex = data.indexOf(';');

    // Check if a space was found AND it's not at the very beginning or end
    if (separatorIndex > 0) {

      // 2. Extract the first part (Motor ID)
      String motorIDStr = data.substring(0, separatorIndex);
      motorID = motorIDStr.toInt();  // Convert the substring to an integer

      // 3. Extract the second part (Angle)
      // Start reading AFTER the space, to the end of the string
      String angleStr = data.substring(separatorIndex + 1);
      angle = angleStr.toInt();  // Convert the substring to an integer

      if (angle < 0 || angle > 360) {  //protection code ensuring the angle is not higher
        motorID = (-1);                // ensures the angle is not used
      }
      // 4. Verification and Action
      client.println("Angle Received!");  // Acknowledge receipt

      // --- Execute the Motor Control Logic ---
      if (motorID == 1) {

        if (xSemaphoreTake(angleMutex, portMAX_DELAY)) {  //ensures safe passing
          angleAzi = angle;
          xSemaphoreGive(angleMutex);
        }

        client.print("Controlling Azimut. Angle: ");
        client.println(angle);


      } else if (motorID == 0) {
        if (xSemaphoreTake(angleMutex, portMAX_DELAY)) {  //ensures safe passing
          angleTilt = angle;
          xSemaphoreGive(angleMutex);
        }
        client.print("Controlling Tilt. Angle: ");
        client.println(angle);


      } else {
        // Neither 0 nor 1 was specified
        client.print("Error: Invalid Motor ID received: ");
        client.println(motorID);
      }

    } else {
      // Handle case where input was received but was not in the expected format (e.g., "1180" or "1 180 extra")
      client.print("Error: Input received but format invalid: ");
      client.println(data);
    }
  }
}

void printData() {
  client.print("Tilt pos: ");
  client.println(pos_tilt);
  client.print("Tilt pos in degrees: ");
  client.println(currentPositionTilt);
  client.print("Tilt error: ");
  client.println(errorTilt);

  //-------DATA OUT--------
  // client.print(millis());
  // client.print("; ");
  client.print("Azi pos: ");
  client.println(pos_azi);
  client.print("Azi pos in degrees: ");
  client.println(currentPositionAzi);
  client.print("Azi error: ");
  client.println(errorAzi);
}