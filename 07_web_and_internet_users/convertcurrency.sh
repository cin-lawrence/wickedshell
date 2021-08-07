# 60 Calculating Currency Values
#!/bin/bahs

# convertcurrency--Civen an amount and base currency, converts it
#   to the specified target currency using ISO currency identifiers
# Uses Google's currency converter for the heavy lifting:
# http://www.google.com/finance/converter
# Note: Google corrency converter is not available

if [ $# -eq 0 ] ; then
  echo "Usage: $(basename $0) amount currency to currency"
  echo "Most common currencies are CAD, CNY, EUR, USD, INR, JPY, and MxN"
  echo "Use \"$(basename $0) list\" for a list of supported currencies."
fi

if [ $(uname) = "Darwin" ] ; then
  LANG=C  # For an issue on OS X with invalid byte sequences and lynx
fi

url="https://finance.google.com/finance/converter"
tempfile="/tmp/converter.$$"
lynx=$(which lynx)

# Since this has multiple uses, let's grab this data before anything else.
currencies=$($lynx -source "$url" | grep "option value=" | \
  cut -d\" -f2- | sed 's/">/ /' | cut -d\( -f1 | sort | uniq)

########## Deal with all non-conversion requests.
if [ $# -ne 4 ] ; then
  if [ "$1" = "list" ] ; then
    # Produce a listing of all currency symbols known by the converter.
    echo "List of supported currencies:"
    echo "$currencies"
  fi
  exit 0
fi

########## Now let's do a conversion.
if [ $3 != "to" ] ; then
  echo "Usage: $(basename $0) value currency TO currency"
  echo "(user \"$(basename $0) list\" to get a list of all currency values)"
  exit 0
fi

amount=$1
basecurrency="$(echo $2 | tr '[:lower:]' '[:upper:]')"
targetcurrency="$(echo $4 | tr '[:lower:]' '[:upper:]')"

$lynx -source "$url?a=$amount&from=$basecurrency&to=$targetcurrency" | \
  grep 'id=currency_converter_result' | sed 's/<[^>]*>//g'

exit 0

