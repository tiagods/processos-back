package com.prolink.processos.utils;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Locale;
 
import jxl.Workbook;
import jxl.WorkbookSettings;
import jxl.format.Border;
import jxl.format.BorderLineStyle;
import jxl.format.Colour;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import jxl.write.biff.RowsExceededException;

public class ExcelGenerico {
    private WritableCellFormat fontCabecalho;
    private WritableCellFormat fontPadrao1;
    private WritableCellFormat fontPadrao2;
     
    private String arquivoSaida;
    private ArrayList<ArrayList<String>> lista;
    private Integer[] larguraColunas;
     
    public ExcelGenerico(String saida, ArrayList<ArrayList<String>> lista, Integer[] larguraColunas){
        this.arquivoSaida=saida;
        this.lista=lista;
        this.larguraColunas=larguraColunas;
    }
    public void gerarExcel() throws NullPointerException, IOException, WriteException{
        WorkbookSettings wbSettings = new WorkbookSettings();
        wbSettings.setLocale(new Locale("pt","BR"));
        File arquivo = new File(arquivoSaida);
        WritableWorkbook workbook = Workbook.createWorkbook(arquivo,wbSettings);
         
        //inserir um nome da planilha
        workbook.createSheet("Plan1", 0);
        WritableSheet sheet = workbook.getSheet(0);
         
        WritableFont font1 = new WritableFont(WritableFont.TIMES,14,WritableFont.BOLD);
        // Define o formato da c�lula
        font1.setColour(Colour.WHITE);
        fontCabecalho = new WritableCellFormat(font1);
        //Colour corBorda = Colour.getInternalColour(new Color(128,125,128).getRGB());
         
        Colour corBorda = Colour.OCEAN_BLUE;
        fontCabecalho.setBackground(Colour.OCEAN_BLUE);
        fontCabecalho.setAlignment(jxl.format.Alignment.CENTRE);
         
        WritableFont font2 = new WritableFont(WritableFont.TIMES,11,WritableFont.BOLD);
        fontPadrao1 = new WritableCellFormat(font2);
        fontPadrao1.setBorder(Border.BOTTOM, BorderLineStyle.HAIR,corBorda);
                fontPadrao1.setWrap(true);
        //fontPadrao1.setBackground(Colour.getInternalColour(new Color(128,122,217).getRGB()));
         
        fontPadrao2 = new WritableCellFormat(font2);
        fontPadrao2.setBorder(Border.BOTTOM, BorderLineStyle.HAIR,corBorda);
        fontPadrao2.setWrap(true);
        //fontPadrao2.setBackground(Colour.getInternalColour(new Color(160,0,240).getRGB()));
        fontPadrao2.setBackground(Colour.WHITE);
        gerarConteudo(sheet, lista);    
         
        workbook.write();
        workbook.close();
    }
    private void gerarConteudo(WritableSheet sheet, ArrayList<ArrayList<String>> lista)throws NullPointerException,WriteException, RowsExceededException{
        if(!lista.isEmpty()){
            //gerando celulas com nome da coluna
            for(int i = 0; i<larguraColunas.length;i++)
                sheet.setColumnView(i, larguraColunas[i]);
            for(int coluna=0; coluna<lista.get(0).size();coluna++){
                addValor(sheet, coluna,0,lista.get(0).get(coluna).toString(),fontCabecalho);
            }
            for(int linha=1;linha<lista.size();linha++){
                WritableCellFormat novoFormato = null;
                if(linha%2==0){
                    novoFormato = fontPadrao2;
                }
                else{
                    novoFormato = fontPadrao1;
                }
                for(int coluna=0;coluna<lista.get(linha).size();coluna++){
                    addValor(sheet, coluna,linha,lista.get(linha).get(coluna).toString(),novoFormato);
                }
            }
        }
    }
    private void addValor(WritableSheet sheet, int coluna, int linha, String s, WritableCellFormat fonte) throws WriteException, RowsExceededException{
        Label label= new Label(coluna, linha, s, fonte);
        sheet.addCell(label);
    }
}
