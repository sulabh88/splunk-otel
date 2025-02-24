variables:
  INPUT_VALUE:
    value: "all"
    description: "Select an input or 'all' from the dropdown, or enter multiple inputs (e.g., input1,input2) for multiple values"
    options:
      - "all"
      - "input1"
      - "input2"
      - "input3"

echo_inputs:
  stage: echo
  image: alpine:latest
  script:
    - |
      # Clean input by removing spaces
      cleaned_input=$(echo "$INPUT_VALUE" | tr -d '[:space:]')
      # Echo the input value(s)
      if [ "$cleaned_input" = "all" ]; then
        echo "All inputs selected: input1, input2, input3"
      else
        echo "Selected input(s): $cleaned_input"
      fi
  when: manual
