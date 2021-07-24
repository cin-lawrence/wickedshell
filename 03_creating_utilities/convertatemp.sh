# 24 Converting Temperatures
#!/bin/basbh

# convertatemp--Temperature conversion script that lets the user enter
#   a temperature in Fahrenheit, Celsius, or Kelvin and receive the
#   equivalent temperature in the other two units as the output

if [ $# -eq 0 ] ; then
  cat << EOF >&2
Usage: $0 temperature [F|C|K]
where the suffix:
  F indicates input is in Fahrenheit (default)
  C indicates input is in Celcius
  K indicates input is in Kelvin
EOF
  exit 1
fi

# unit="$(echo $@ | sed -e 's/[-[:digit:]]*//g' | awk '{$1=$1};1' | tr '[:lower:]' '[:upper:]')"
unit="$(echo $@ | sed -e 's/[-[:digit:] ]*//g' | tr '[:lower:]' '[:upper:]')"
temp="$(echo $@ | sed -e 's/[^-[:digit:]]*//g')"

case ${unit:-F} in
  F )  # Fahrenheit to Celcius formula: Tc = (F - 32) / 1.8
    farn="$temp"
    cels="$(echo "scale=2; ($farn - 32) / 1.8" | bc)"
    kelv="$(echo "scale=2; $cels + 273.15" | bc)"
    ;;
  C )  # Celcius to Fahrenheit formula: Tf = (9 / 5) * Tc + 32
    cels="$temp"
    farn="$(echo "scale=2; (1.8 * $cels) + 32" | bc)"
    kelv="$(echo "scale=2; $cels + 273.15" | bc)"
    ;;
  K )  # Celcius = Kelvin - 273.15, then use Celcuis -> Fahrenheit formula
    kelv="$temp"
    cels="$(echo "scale=2; $kelv - 273.15" | bc)"
    farn="$(echo "scale=2; (1.8 * $cels) + 32" | bc)"
    ;;
  * )
    echo "Given temperature unit is not supported"
    exit 1
esac

echo "Fahrenheit = $farn"
echo "Celcius = $cels"
echo "Kelvin = $kelv"

exit 0
