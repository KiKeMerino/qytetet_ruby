#encoding: utf-8
module ModeloQytetet
  class TituloPropiedad
    attr_accessor :nombre, :precioCompra, :alquilerBase, :factorRevalorizacion
    attr_reader :hipotecaBase, :precioEdificar, :numHoteles, :numCasas
    attr_accessor :hipotecada, :propietario
    def initialize (name, prize, rent, factor, hipoteca_base, precio_edificar)
      @nombre=name
      @hipotecada=false
      @precioCompra=prize
      @alquilerBase=rent
      @factorRevalorizacion=factor
      @hipotecaBase=hipoteca_base
      @precioEdificar=precio_edificar
      @numHoteles=0
      @numCasas=0
      @propietario = nil
    end
    
    def to_s
      "\nNombre: #{@nombre} \nHipotecada: #{@hipotecada} \nPrecio de compra: #{@precioCompra}"+
      "\nAlquiler base: #{@alquilerBase} \nFactor de revalorizacion: #{@factorRevalorizacion}"+
      "\nHipoteca base: #{@hipotecaBase} \nPrecio edificar: #{@precioEdificar}"+
      "\nNumero de hoteles: #{@numHoteles} \nNumero de casas: #{@numCasas}"
    end

    def calcularCosteCancelar
      coste=Integer(calcularCosteHipotecar+0.1)
    end
    
    def calcularCosteHipotecar
      costeHipotecar = Integer (@hipotecaBase + @numCasas * 0.5 * @hipotecaBase + @numHoteles * @hipotecaBase)
    end
    
    def calcularImporteAlquiler
      costeAlquiler = Integer (@alquilerBase + (@numCasas * 0.5 + @numHoteles * 2))
    end
 
    def calcularPrecioVenta 
      precioVenta = Integer (@precioCompra + (@numCasas + @numHoteles) * @precioEdificar * @factorRevalorizacion)
    end
    
    def cancelarHipoteca
      @hipotecada=true
    end

    def edificarCasa
     @numCasas+=1
    end
    
    def edificarHotel
      @numCasas=0
      @numHoteles+=1
    end
    
    def hipotecar
      costeHipotecar = calcularCosteHipotecar
      @hipotecada = true
      costeHipotecar
    end
    
    def pagarAlquiler
      costeAlquiler = calcularImporteAlquiler
      @propietario.modificarSaldo(costeAlquiler)
      costeAlquiler
    end
    
    def propietarioEncarcelado
      
      resultado = @propietario.encarcelado 
      
    end
    
    def tengoPropietario
      
      propietario=false
      if @propietario!=nil
        propietario=true
      end
      propietario
      
    end

  end
end
