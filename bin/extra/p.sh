#!/bin/sh

ask_pokemon() { commander -xc < ./pokemon_bw.txt; }

html="/tmp/pk_tmp.html"
[ "$pokemon" ] || pokemon="$(ask_pokemon)"
[ "$pokemon" ] || exit 1

case "$1" in
    # evolution
    e*)
        url="https://pokemondb.net/pokedex/$pokemon"
        curl -Ls "$url" > "$html"
        level1="$(pup -p 'span.infocard:nth-child(2) > small:nth-child(2) text{}' < "$html")"
        level2="$(pup -p 'span.infocard:nth-child(4) > small:nth-child(2) text{}' < "$html")"
        notify-send "p.sh" "$level1\n$level2"
    ;;

    # moves
    m*) $BROWSER "https://bulbapedia.bulbagarden.net/wiki/${pokemon}_(Pok%C3%A9mon)/Generation_V_learnset" ;;

    # stats
    s*) $BROWSER "https://www.smogon.com/dex/bw/pokemon/$pokemon/" ;;
    *)  
        choice="$(printf 'evolution\nmoves\nstats\n' | commander -c -w 3)"
        [ "$choice" ] && pokemon="$pokemon" $0 "$choice" ;;
esac
