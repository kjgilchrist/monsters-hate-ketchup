int counter = 0;

void setup() {
  //I hope this works.
  Serial.begin(57600);
  Keyboard.begin();
}

void loop() {
  // put your main code here, to run repeatedly:
  if (counter < 1) {
    Keyboard.write('a');
    Keyboard.print("'a' Button pressed");
    Serial.print("'a' Button pressed");
  }
  counter++;
}
