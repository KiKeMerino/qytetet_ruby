#encoding: utf-8
module ModeloQytetet
  class Sorpresa
    
    attr_accessor :texto, :valor, :tipo
    
    def initialize(text, value, type)
      @texto=text
      @valor=value
      @tipo=type
    end
    
    def to_s
      "\nTexto: #{@texto} \nValor: #{@valor} \nTipo: #{@tipo}\n"
    end 
  end
end
