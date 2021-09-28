#encoding: utf-8
require_relative "sorpresa"
require_relative "tipo_sorpresa"
require_relative "tablero"
require_relative "qytetet"
require_relative "jugador"

module ModeloQytetet
  
  class PruebaQytetet
    @@juego=Qytetet.instance
    
    def self.main
         
    def self.mayor_que_0
      
      cartas=Array.new
      
      for i in @@juego.mazo
        if i.valor > 0
          cartas<< i
        end
      end
      
      return cartas
    end
    
    def self.sorpresas_ir_a_casilla
      
      cartas=Array.new
      
      for i in @@juego.mazo
        if i.tipo == TipoSorpresa::IRACASILLA
          cartas<< i
        end
      end
      
      return cartas
    end
    
    def self.sorpresas_a_elegir(tipo_sorpresa)
      
      cartas=Array.new
      
      for i in @@juego.mazo
        if i.tipo == tipo_sorpresa
          cartas<< i
        end
      end
      
      return cartas
    end
    
   
    
    def self.getsNombreJugadores 
      entero = gets
      nombres=Array.new
      for i in (1..Integer(entero))
        nombres<<gets
      end
      
      nombres
    end
    
    
      names=Array.new
      names=PruebaQytetet.getsNombreJugadores   
      @@juego.inicializarJuego(names)
      puts @@juego.to_s
      
      for j in @@juego.mazo
        puts j.to_s
      end
      
      for a in @@juego.jugadores
         puts a.to_s
      end
      
      puts @@juego.tablero.to_s
      
    puts "\n\n-------------------------------\n\n"
    
    casillaDelJugador=@@juego.obtenerCasillaJugadorActual
    puts "El jugador actual es: #{@@juego.jugadorActual.nombre} y esta en la casilla: #{casillaDelJugador.numeroCasilla}\n\n" 
    
    @@juego.mover(5);
    
    casillaDelJugador=@@juego.obtenerCasillaJugadorActual
    puts "El jugador actual es: #{@@juego.jugadorActual.nombre} y esta en la casilla: #{casillaDelJugador.numeroCasilla}\n\n" 

    comprado=@@juego.comprarTituloPropiedad
    puts "El resultado de la operacion de compra ha sido: #{comprado}"
    puts "El jugador actual es: #{@@juego.jugadorActual.nombre} y tiene de saldo #{@@juego.jugadorActual.saldo} 
    y sus propiedades son:\n"
    for l in @@juego.jugadorActual.propiedades
      puts l.nombre
    end
    
    puts"\n\n--------------------------------\n\n"
    
    @@juego.venderPropiedad(5)
    puts "El jugador actual es: #{@@juego.jugadorActual.nombre} y tiene de saldo #{@@juego.jugadorActual.saldo} 
    y sus propiedades son:\n"
    for l in @@juego.jugadorActual.propiedades
      puts l.nombre
    end
    
    puts"\n\n--------------------------\n\n"
    
    @@juego.siguienteJugador
    
    casillaDelJugador=@@juego.obtenerCasillaJugadorActual
    casillaDelJugador=@@juego.obtenerCasillaJugadorActual
    puts "El jugador actual es: #{@@juego.jugadorActual.nombre} y esta en la casilla: #{casillaDelJugador.numeroCasilla}\n\n" 
    
    @@juego.mover(4);
    
    casillaDelJugador=@@juego.obtenerCasillaJugadorActual
    puts "El jugador actual es: #{@@juego.jugadorActual.nombre} y esta en la casilla: #{casillaDelJugador.numeroCasilla}\n\n" 

    @@juego.aplicarSorpresa
    casillaDelJugador=@@juego.obtenerCasillaJugadorActual
    puts "El jugador actual es: #{@@juego.jugadorActual.nombre} y tiene de saldo #{@@juego.jugadorActual.saldo} 
    y sus propiedades son:\n"
    puts"\n\n-----------------------------------------\n\n"
    @@juego.mover(15);
    casillaDelJugador=@@juego.obtenerCasillaJugadorActual
    puts "\n\nEl jugador actual es: #{@@juego.jugadorActual.nombre} y esta en la casilla: #{casillaDelJugador.numeroCasilla}\n\n"
    puts "El jugador esta encarcelado?: #{@@juego.jugadorActual.encarcelado}"
    
    puts "\n\n----------------------------------------\n\n"
    @@juego.intentarSalirCarcel(MetodoSalirCarcel::PAGANDOLIBERTAD)
    puts "El jugador esta encarcelado?: #{@@juego.jugadorActual.encarcelado}"
    puts "\n\nEl jugador actual tiene de saldo: #{@@juego.jugadorActual.saldo} y esta en la casilla: #{casillaDelJugador.numeroCasilla}\n\n"

    
  end
  end
  PruebaQytetet.main
end
