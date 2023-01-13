#include <EloquentTinyML.h>
#include <eloquent_tinyml/tensorflow.h>

// model.h contains the array exported from Python with xxd
#include "model.h"

// Same in and outputs as trained
#define N_INPUTS 1
#define N_OUTPUTS 1
// in future projects you may need to tweak this value: it's a trial and error process
#define TENSOR_ARENA_SIZE 2 * 1024

// Make the TensorFlow network
Eloquent::TinyML::TensorFlow::TensorFlow<N_INPUTS, N_OUTPUTS, TENSOR_ARENA_SIZE> tf;

// Full sine wave is 2 times PI
const float range = 2.f * 3.14159265359f;
const int inferencesPerCycle = 40;
int inference_count = 0;


void setup() {
  Serial.begin(115200);
  delay(500);
  // Load the model
  tf.begin(model_tflite);

  // check if model loaded fine
  if (!tf.isOk()) {
    Serial.print("ERROR: ");
    Serial.println(tf.getErrorMessage());

    while (true) delay(1000);
  }
}

void loop() {
  float position = static_cast<float>(inference_count) / 
                   static_cast<float>(inferencesPerCycle);
  
  float x = position * range;
  // Correct value of the sine wave
  float y = sin(x);
  // Pass the same X value to the AI
  float input[1] = { x };
  // And get a prediction back
  float predicted = tf.predict(input);

  // Print out the values
  // Use the Serial plotter to see output
  Serial.print("actuale:");
  Serial.print(y);
  Serial.print(",");
  Serial.print("predicted:");
  Serial.println(predicted);

  // When at the end, start back at start
  inference_count += 1;
  if (inference_count >= inferencesPerCycle) inference_count = 0;
  delay(75);
}
