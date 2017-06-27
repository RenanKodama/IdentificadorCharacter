#Renan Kodama Rodrigues   1602098
#Mateus Yonemoto Peixoto  1602055

pkg load image;

#############################TXT#######################################
function percentQuadrantes(I,arquivo)  
  linhas = rows(I);
  colunas = columns(I);
  total = linhas * colunas;
  
  qtd_divisao = 4;
            
  linha_div = [0]; 
  coluna_div = [0];
          
  vetLPixelPreto = [];            
  qtdPixelPreto2 = 0; 
            
  for (i = 2 : qtd_divisao) 
    linha_div(end + 1, :) = floor((linha_div(end) + linhas / qtd_divisao)) - 1;
    coluna_div(end + 1, :) = floor((coluna_div(end) + colunas / qtd_divisao)) - 1;
  end
            
  linha_div(end + 1, :) = linhas;
  coluna_div(end + 1, :) = colunas;
            
  for(i = 1 : qtd_divisao)  
    for(j = 1 : qtd_divisao)
      for(a = linha_div(i) + 1 : linha_div(i+1))
        for(b = coluna_div(j) + 1 : coluna_div(j+1))                 
          if I(a,b) == 1
            qtdPixelPreto2 = qtdPixelPreto2 + 1;
          endif 
        endfor
      endfor
      vetLPixelPreto(end + 1, :) = qtdPixelPreto2;          
      qtdPixelPreto2 = 0;
    endfor
  endfor
  
  for i = 1:size(vetLPixelPreto)
    vetLPixelPreto(i) = (vetLPixelPreto(i)/total)*100;
  endfor

  for i = 1:(size(vetLPixelPreto))
    fprintf(arquivo,"%.4f ",vetLPixelPreto(i));
  endfor  
endfunction

#funçao que extrai a porcentagem total de pixels no sentido Vertical
function histograma_V(I,arquivo)
  numBlackPixel = 0;  
  
  linhas = rows(I);
  colunas = columns(I);

  numTotalPixel = linhas * colunas;
  
  for i = (1:linhas)
    for j = ((colunas/2)-1):((colunas/2)+1)  
      if(I(cast(i,"uint32"),cast(j,"uint32")) == 1)
        numBlackPixel++;
      endif
    endfor
  endfor
  
  percentBlackPixel = (numBlackPixel/numTotalPixel)*100; 
  
  fprintf(arquivo,"%.4f ",percentBlackPixel);
endfunction

#funçao que extrai a porcentagem total de pixels no sentido Horizontal
function histograma_H(I,arquivo)
  numBlackPixel = 0;  
  
  linhas = rows(I);
  colunas = columns(I);
  
  numTotalPixel = linhas * colunas;
  
  for i = ((linhas/2)-1):((linhas/2)+1)
    for j = 1:colunas
      if(I(cast(i,"uint32"),cast(j,"uint32")) == 1)
        numBlackPixel++;
      endif  
    endfor
  endfor
  
  percentBlackPixel = (numBlackPixel/numTotalPixel)*100;
  
  fprintf(arquivo,"%.4f ",percentBlackPixel);
endfunction
  
#funçao que extrai a porcentagem total de pixels Black da Metade Esquerda
function percentMetadeLeft(I,arquivo)
  numBlackPixel = 0;
  numTotalPixel = ((rows(I))*(columns(I))) /2;  
  
  for i = (1:(rows(I)))
    for j = (1:columns(I)/2)  
      if(I(cast(i,"uint32"),(cast(j,"uint32"))) == 1) 
        numBlackPixel++;
      endif
    endfor
  endfor
  
  percentBlackPixel = (numBlackPixel / numTotalPixel) * 100;
  
  fprintf(arquivo,"%.4f ",percentBlackPixel);
endfunction  
  
#funçao que extrai a porcentagem total de pixels Black da Metade Superior
function percentMetadeUp(I,arquivo)
  numBlackPixel = 0;
  numTotalPixel = ((rows(I))*(columns(I))) /2;  
  
  for i = (1:(rows(I)/2))
    for j = (1:columns(I))
      if(I(cast(i,"uint32"),(cast(j,"uint32"))) == 1)
        numBlackPixel++;
      endif
    endfor
  endfor
  
  percentBlackPixel = (numBlackPixel / numTotalPixel) * 100;

  fprintf(arquivo,"%.4f ",percentBlackPixel);
endfunction
  
#funçao que extrai a porcentagem total de pixels Black e White
function percentBlackWhitePixels(I,arquivo)
  numBlackPixel = 0;
  numWhitePixel = 0;
  
  for i = (1:rows(I))
    for j = (1:columns(I))
      if(I(cast(i,"uint32"),(cast(j,"uint32"))) == 1)
        numBlackPixel++;
    
      else
        numWhitePixel++;     
      endif
    endfor
  endfor
  
  numTotalPixel = rows(I) * columns(I);
  
  percentBlackPixel = (numBlackPixel / numTotalPixel) * 100;
  percentWhitePixel = (numWhitePixel / numTotalPixel) * 100;
  
  fprintf(arquivo,"%.4f ",percentBlackPixel);
  fprintf(arquivo,"%.4f ",percentWhitePixel);
endfunction     
#############################END-TXT#######################################
 
 
#Main{
  arquivoTest = fopen("./Train_Test_Validation/NIST_Test_Upper_Lit.txt");
  arquivoSaidaTest = fopen("testLit.txt","w");
  
  while ~feof(arquivoTest)
    linha = fscanf(arquivoTest,"%s",1);
    if ~isempty(linha)
      #printf("%s",linha);
      
      arquivo = strcat("./Imagens",linha);
      
      I = imread(arquivo);
      #imshow(I), figure;
      resize(I,32,32);
      
      percentBlackWhitePixels(I,arquivoSaidaTest);
      percentMetadeUp(I,arquivoSaidaTest);
      percentMetadeLeft(I,arquivoSaidaTest);
      percentQuadrantes(I,arquivoSaidaTest);      
      histograma_H(I,arquivoSaidaTest);
      histograma_V(I,arquivoSaidaTest);

      switch (linha(2)) 
        case("a")
          fprintf(arquivoSaidaTest,"0.00");
        case("b")    
          fprintf(arquivoSaidaTest,"1.00");
        case("c")    
          fprintf(arquivoSaidaTest,"2.00");
        case("d")
          fprintf(arquivoSaidaTest,"3.00");
        case("e")
         fprintf(arquivoSaidaTest,"4.00");
        case("f")
          fprintf(arquivoSaidaTest,"5.00");
        case("g")
          fprintf(arquivoSaidaTest,"6.00");
        case("h")
          fprintf(arquivoSaidaTest,"7.00");
        case("i")
          fprintf(arquivoSaidaTest,"8.00");
        case("j")
          fprintf(arquivoSaidaTest,"9.00");
        case("k")
          fprintf(arquivoSaidaTest,"10.00");
        case("l")
          fprintf(arquivoSaidaTest,"11.00");
        case("m")
          fprintf(arquivoSaidaTest,"12.00");
        case("n")
          fprintf(arquivoSaidaTest,"13.00");
        case("o")
          fprintf(arquivoSaidaTest,"14.00");
        case("p")
          fprintf(arquivoSaidaTest,"15.00");
        case("q")
          fprintf(arquivoSaidaTest,"16.00");
        case("r")
          fprintf(arquivoSaidaTest,"17.00");
        case("s")
          fprintf(arquivoSaidaTest,"18.00");
        case("t")
          fprintf(arquivoSaidaTest,"19.00");
        case("u")
          fprintf(arquivoSaidaTest,"20.00");
        case("v")
          fprintf(arquivoSaidaTest,"21.00");
        case("w")
          fprintf(arquivoSaidaTest,"22.00");
        case("x")
          fprintf(arquivoSaidaTest,"23.00");
        case("y")
          fprintf(arquivoSaidaTest,"24.00");
        case("z")
          fprintf(arquivoSaidaTest,"25.00");
        otherwise
          printf("nada\n");
      endswitch
      
      fprintf(arquivoSaidaTest,"\n");  
    endif         
  endwhile
  fclose(arquivoSaidaTest);
  fclose(arquivoTest);
#end_Main}

  printf("Done\n"); 
###########################END_MAIN()