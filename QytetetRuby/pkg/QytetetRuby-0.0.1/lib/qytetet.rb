#encoding: utf-8
require_relative "tipo_sorpresa"
require_relative "sorpresa"
require_relative "tablero"
require_relative "dado"
require_relative "metodo_salir_carcel"
require_relative "jugador"
require_relative "estado_juego"
require_relative "especulador"
require "singleton"
module ModeloQytetet
  class Qytetet
    include  Singleton
    
      @@max_jugadores=4
      @@num_sorpresas=10
      @@num_casillas=20
      @@precio_libertad=200
      @@saldo_salida=1000
      @@estado_juego=nil
      
    attr_accessor :mazo, :tablero, :num_casillas, :precio_libertad
    attr_accessor :num_sorpresa, :saldo_salida, :cartaActual
    attr_accessor :dado, :jugadorActual, :jugadores
    
    def initialize
      @mazo=Array.new
      @tablero=Tablero.new
      @jugadores=Array.new
      @cartaActual =nil
      @dado = Dado.instance
      @jugadorActual=nil
      
      
    end
    
  def inicializar_cartas_sorpresa
    #tipo CONVERTIRME
      @mazo<< Sorpresa.new("Te hemos pillado especulando, ahora eres un especulador", 3000, TipoSorpresa::CONVERTIRME)
      @mazo<< Sorpresa.new("La venta de tus acciones te asciende a especulador", 5000, TipoSorpresa::CONVERTIRME)
    # tipo IRACASILLA
      @mazo<< Sorpresa.new("Te pillamos con la mafia, sospechamos que perteneces a ella, 
                             lo sentimos, ¡A LA CARCEL!", 9, TipoSorpresa::IRACASILLA)
      @mazo<< Sorpresa.new("Enhorabuena, has pillado un anticiclon encima, 
                          vaya a la calle BuenDia", 19, TipoSorpresa::IRACASILLA)
      @mazo<< Sorpresa.new("Acuda a Gotham, 
                          la biribimafia le necesita", 10, TipoSorpresa::IRACASILLA)
    # tipo SALIRCARCEL
      @mazo<< Sorpresa.new("La biribimafia te ha seleccionado ¡Que honor!, 
                          cuando vayas a la carcel te sacaran", 0, TipoSorpresa::SALIRCARCEL)
    # tipo PAGARCOBRAR
      @mazo<< Sorpresa.new("¡MULTA!, te hemos pillado pisando hormigas 
                          y asesinando moscas, paga 500", -500, TipoSorpresa::PAGARCOBRAR)
      @mazo<< Sorpresa.new("¡BUENA SUERTE! has ganado en la ruleta, 
                          cobra 600", 600, TipoSorpresa::PAGARCOBRAR)
    # tipo PORCASAHOTEL
      @mazo<< Sorpresa.new("La hacienda ha descubierto tu contrabando, 
               paga 200 por cada hotel o casa de tu propiedad", -200, TipoSorpresa::PORCASAHOTEL)
      @mazo<< Sorpresa.new("¡QUE SUERTE!, un ladron muy generoso ha robado un banco 
        y te ha soltado 300 en cada casa y hotel de tu propiedad ", 300, TipoSorpresa::PORCASAHOTEL)
    # tipo PORJUGADOR
      @mazo<< Sorpresa.new("Tus compañeros te tienen bastante pelusilla, 
            se han aliado para quitarte 400 cada uno de la cartera ", -400, TipoSorpresa::PORJUGADOR) 
      @mazo<< Sorpresa.new("Tus compañeros te tienen miedo, 
                te pagan 200 cada uno para que no les hagas nada", 200, TipoSorpresa::PORJUGADOR)
      
      @mazo.shuffle
  end
    def self.get_estadoJuego
      @@estado_juego
    end
    
    def self.set_estadoJuego(estado)
      @@estado_juego = estado
    end

    def inicializarTablero
      @tablero=Tablero.new
    end

    def actuarSiEnCasillaEdificable
      deboPagar = @jugadorActual.deboPagarAlquiler
      if deboPagar
        @jugadorActual.pagarAlquiler
        if @jugadorActual.saldo<=0
          @@estado_juego = EstadoJuego::ALGUNJUGADORENBANCARROTA
        end
      end
      casilla = obtenerCasillaJugadorActual
      tengoPropietario = casilla.tengoPropietario
      
      if @@estado_juego != EstadoJuego::ALGUNJUGADORENBANCARROTA
        if tengoPropietario
          @@estado_juego = EstadoJuego::JA_PUEDEGESTIONAR
        else
           @@estado_juego = EstadoJuego::JA_PUEDECOMPRAROGESTIONAR
        end
       
     end
    end
   
    def actuarSiEnCasillaNoEdificable
      @@estado_juego = EstadoJuego::JA_PUEDEGESTIONAR
      casillaActual = @jugadorActual.casillaActual
      
      if casillaActual.tipo == TipoCasilla::IMPUESTO
        @jugadorActual.pagarImpuesto
        if @jugadorActual.saldo<=0
          @@estado_juego=EstadoJuego::ALGUNJUGADORENBANCARROTA
        end
      end
      
      if casillaActual.tipo == TipoCasilla::JUEZ
        encarcelarJugador
      end
      
      if casillaActual.tipo == TipoCasilla::SORPRESA
        @cartaActual=@mazo.shift
       @@estado_juego = EstadoJuego::JA_CONSORPRESA
      end
        
    end
    
    def aplicarSorpresa
      @@estado_juego = EstadoJuego::JA_PUEDEGESTIONAR
      if @cartaActual.tipo == TipoSorpresa::SALIRCARCEL
        @jugadorActual.cartaLibertad = @cartaActual
      else
        @mazo << @cartaActual
        
        if @cartaActual.tipo == TipoSorpresa::PAGARCOBRAR
          @jugadorActual.modificarSaldo(@cartaActual.valor)
          if @jugadorActual.saldo<=0
            @@estado_juego = EstadoJuego::ALGUNJUGADORENBANCARROTA
          end
        end  
        if @cartaActual.tipo==TipoSorpresa::IRACASILLA
          valor=@cartaActual.valor
          casillaCarcel=tablero.esCasillaCarcel(valor)
          if casillaCarcel==true
            encarcelarJugador
          else
            mover(valor)
          end
        end
          
        if @cartaActual.tipo==TipoSorpresa::PORCASAHOTEL
          cantidad=@cartaActual.valor
          numeroTotal=@jugadorActual.cuantasCasasHotelesTengo
          @jugadorActual.modificarSaldo(cantidad*numeroTotal)
          if @jugadorActual.saldo<=0
            @@estado_juego=EstadoJuego::ALGUNJUGADORENBANCARROTA
          end
        end
        if @cartaActual.tipo==TipoSorpresa::PORJUGADOR
          for i in @jugadores
            if i != @jugadorActual
              i.modificarSaldo(@cartaActual.valor)
              if i.saldo<=0
                @@estado_juego=EstadoJuego::ALGUNJUGADORENBANCARROTA
              end
              @jugadorActual.modificarSaldo(-@cartaActual.valor)
              if @jugadorActual.saldo<=0
                @@estado_juego=EstadoJuego::ALGUNJUGADORENBANCARROTA
              end
            end
          end
        end
        if @cartaActual.tipo==TipoSorpresa::CONVERTIRME
          especulador=@jugadorActual.convertirme(@cartaActual.valor)
          encontrado=false
          posicion=0
          for i in @jugadores
            if !encontrado
              if i=@jugadorActual
                encontrado=true
              else
               posicion+=posicion
              end
            end     
          end
          @jugadores[posicion]=especulador
          @jugadorActual=@jugadores[posicion]
        end
      end
    end
      
    def cancelarHipoteca(numero_casilla)
      casilla=@tablero.obtenerCasillaNumero(numero_casilla)
      titulo=casilla.titulo
      hipotecaCancelada=@jugadorActual.cancelarHipoteca
      @@estado_juego=EstadoJuego::JA_PUEDEGESTIONAR
      hipotecaCancelada
    end
    
    def comprarTituloPropiedad
      comprado = @jugadorActual.comprarTituloPropiedad
      if comprado == true
        @@estado_juego = EstadoJuego::JA_PUEDEGESTIONAR 
      end
      
      comprado
    end
    
    def edificarCasa(numero_casilla)
      edificada = false
      casilla = @tablero.obtenerCasillaNumero(numero_casilla)
      titulo = casilla.titulo
      edificada = @jugadorActual.edificarCasa(titulo)
      
      if edificada == true
        @@estado_juego = EstadoJuego::JA_PUEDEGESTIONAR
      end
      
      edificada
    end
    
    def edificarHotel(numero_casilla)
      edificada=false
      casilla=@tablero.obtenerCasillaNumero(numero_casilla)
      titulo=casilla.titulo
      edificada=@jugadorActual.edificarHotel(titulo)
      if edificada ==true
        @@estado_juego=EstadoJuego::JA_PUEDEGESTIONAR
      end
      edificada
    end
    
    def encarcelarJugador
      if @jugadorActual.deboIrACarcel
        casillaCarcel = @tablero.carcel
        @jugadorActual.irACarcel(casillaCarcel)
        @@estado_juego = EstadoJuego::JA_ENCARCELADO
      else
        carta = @jugadorActual.devolverCartaLibertad
        @mazo << carta
        @@estado_juego = EstadoJuego::JA_PUEDEGESTIONAR
      end
      
    end
    
    def hipotecarPropiedad(numero_casilla)
      casilla = @tablero.obtenerCasillaNumero(numero_casilla)
      titulo = casilla.titulo
      @jugadorActual.hipotecarPropiedad(titulo)
      @@estado_juego = EstadoJuego::JA_PUEDEGESTIONAR
    end
 
    def inicializarJuego(nombres)
      inicializarTablero
      inicializarJugadores(nombres)
      inicializar_cartas_sorpresa
      salidaJugadores
      
    end
    
    def inicializarJugadores(nombres) 
      
      for n in nombres
        @jugadores << Jugador.nuevo(n)
      end
    end
   
    def intentarSalirCarcel(metodo)
      if metodo ==MetodoSalirCarcel::TIRANDODADO
        resultado = tirarDado
        if resultado >=5
          @jugadorActual.encarcelado = false
        end
        
      end
      
      if metodo == MetodoSalirCarcel::PAGANDOLIBERTAD
        @jugadorActual.pagarLibertad(@@precio_libertad)
      end
      
      encarcelado = @jugadorActual.encarcelado
      if encarcelado
        @@estado_juego = EstadoJuego::JA_ENCARCELADO
      end
      
      if !encarcelado
        @@estado_juego = EstadoJuego::JA_PREPARADO
      end
      
      !encarcelado
    end
    
    def jugar
      
      valor=tirarDado
      casilla=@tablero.obtenerCasillaFinal(@jugadorActual.casillaActual, valor)
      mover(casilla.numeroCasilla)
      
    end
    
    def mover(num_casilla_destino)
      casillainicial = @jugadorActual.casillaActual
      casillaFinal = @tablero.obtenerCasillaNumero(num_casilla_destino)
      @jugadorActual.casillaActual = casillaFinal
      
      if num_casilla_destino < casillainicial.numeroCasilla
        @jugadorActual.modificarSaldo(@@saldo_salida)
      end
      
      if casillaFinal.soyEdificable
        actuarSiEnCasillaEdificable
      else
        actuarSiEnCasillaNoEdificable
      end
      
    end
    
    def obtenerCasillaJugadorActual
      @jugadorActual.casillaActual
    end

    def obtenerCasillasTablero
      @tablero.casillas
    end

    def obtenerPropiedadesJugador
      
      prop=Array.new
      for i in @jugadorActual.propiedades
        for j in @tablero.casillas
          if i.nombre == j.titulo.nombre
            prop << j.numeroCasilla
          end
        end
      end
      prop

    end

    def obtenerPropiedadesJugadorSegunEstadoHipoteca(estado_hipoteca) 
      
      prop=Array.new
      propiedades=Array.new
      prop=@jugadorActual.obtenerPropiedades(estado_hipoteca)
      for i in prop
        for j in @tablero.casillas
          if i.nombre == j.titulo.nombre
            propiedades << j.numeroCasilla
          end
        end
      end
      propiedades
      
    end
 
    def obtenerRanking
      @jugadores=@jugadores.sort
    end
    
    def obtenerSaldoJugadorActual
      valor=@jugadorActual.saldo
    end
    
    def obtenerValorDado
      @dado.valor
    end
    
    def salidaJugadores
      
      numeroJug=0
      for i in @jugadores
        i.casillaActual=Casilla.new(0,TipoCasilla::SALIDA)
        numeroJug+=numeroJug
      end
      jugadorRandom=Random.rand(1..@jugadores.length)
      @jugadorActual=@jugadores[jugadorRandom-1]
      @@estado_juego=EstadoJuego::JA_PREPARADO
      
    end

    def siguienteJugador
      
      posicion=0
      
      for i in @jugadores
        if i==@jugadorActual
          @jugadorActual=@jugadores[(posicion+1)%@jugadores.length]
        else
          (posicion+=1)%@jugadores.length
        end
      end
      if @jugadorActual.encarcelado == true
        @@estado_juego=EstadoJuego::JA_ENCARCELADOCONOPCIONDELIBERTAD
      else
        @@estado_juego=EstadoJuego::JA_PREPARADO
      end
      
    end
    
    def tirarDado
      valor=@dado.tirar
    end
    
    def venderPropiedad(numero_casilla)
      casilla = @tablero.obtenerCasillaNumero(numero_casilla)
      @jugadorActual.venderPropiedad(casilla)
      @@estado_juego=EstadoJuego::JA_PUEDEGESTIONAR
    end
    
 

    def to_s
      @tablero.to_s
      puts "\nCARTAS SORPRESA: "
      puts @mazo
      puts "\nJUGADORES: "
      puts "\nTOTAL DE JUGADORES: #{@jugadores.size}"
      puts @jugadores
    end
    
    private 
      :encarcelarJugador
      :inicializarCartasSorpresa
      :inicializarJugadores
      :inicializarTablero
      :salidaJugadores
    public
      :aplicarSorpresa
      :cancelarHipoteca
      :comprarTituloPropiedad
      :edificarCasa
      :edificarHotel
      :hipotecarPropiedad
      :inicializarJuego
      :intentarSalirCarcel
      :jugar
      :obtenerCasillaJugadorActual
      :obtenerCasillasTablero
      :obtenerPropiedadesJugador
      :obtenerPropiedadesJugadorSegunEstadoHipoteca
      :obtenerRanking
      :obtenerSaldoJugadorActual
      :obtenerValorDado
      :siguienteJugador
      :venderPropiedad      
  end
  
end
