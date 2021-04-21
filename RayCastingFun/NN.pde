class NN {
  int num_of_inputs;
  int num_of_hidden;
  int num_of_outputs;

  int num_of_weights;
  int num_of_biases;

  float[] inputs;
  float[] biases;
  float[] weights;
  float[] outputs;

  float[] hidden_outputs;

  NN (float all_inputs[], int numH, int numO) {
    inputs = all_inputs;
    num_of_inputs = inputs.length;

    num_of_hidden = numH;

    num_of_outputs = numO;

    initialize();
  }

  void initialize() {
    num_of_weights = ((num_of_inputs*num_of_hidden)+(num_of_hidden*num_of_outputs));
    num_of_biases = num_of_hidden+num_of_outputs;
    hidden_outputs = new float [num_of_hidden];
    weights = new float[num_of_weights];
    biases = new float[num_of_biases];
    outputs = new float[num_of_outputs];
  }

  void randomize() {
    for (int i = 0; i < weights.length; i++) {
      weights[i] = random(-1, 1);
    }
    for (int i = 0; i < biases.length; i++) {
      biases[i] = random(-1, 1);
    }
  }

  void compute() {
    for (int i = 0; i < num_of_hidden; i++) {
      for (int x = 0; x < num_of_inputs; x++) {
        hidden_outputs[i] += inputs[x]*weights[x];
      }
      hidden_outputs[i] += biases[i];
      if (hidden_outputs[i] < 0) {
        hidden_outputs[i] = 0;
      }
    }

    for (int i = 0; i < num_of_outputs; i++) {
      for (int x = 0; x < num_of_hidden; x++) {
        outputs[i] += hidden_outputs[x]*weights[(num_of_inputs*num_of_hidden)+x];
      }
      outputs[i] += biases[num_of_hidden+i];
      
      outputs[i] = (float)Math.tanh(outputs[i]);
    }
  }
}
