$outputpath="C:\servers.htm"
$result= $null; 
$targetIPadress = $null;
$resultSets = $null;

####結果出力用のTxtをあらかじめ作成しておく###
New-Item c:\resultSets.txt -type file -force 

####エクセルからIPアドレスと機器名の取得##########
$filePath = Get-ChildItem C:\ipList.xlsx
$excel = New-Object -comobject Excel.Application  
$excel.Visible = $False  
$workBooks = $excel.Workbooks.Open($filePath)  

#Sheet1を取得する  
$workbooks.Worksheets | % { if ($_.Index -eq 1) { $sheet = $_; }}  

for ( $i = 2; $i -lt 50000; $i++ ){
    if($sheet.Cells.Item($i,1).Text){
        $targetIPadress = $sheet.Cells.Item($i,1).Text;
        $target = $sheet.Cells.Item($i,2).Text;
        
        #########IPコネクションテスト#########
        if (Test-Connection  $targetIPadress -quiet) {
            $result = '起動中'
        }else{
            $result = '死亡'
        }
        $resultSets = $target+','+$result;
        
        #########結果をtxtに出力#########
        $resultSets | Out-File c:\resultSets.txt -append
        
    }else{
        break;
    }
}
$workBooks.Close();
$excel.Quit();
$resultSets

#########html出力#########
$outputdata = Get-Content c:\resultSets.txt;
$html =  $outputdata | ConvertFrom-Csv -Header "PC名","IsAlive" | ConvertTo-Html -Head $head -Title "Servers"  
$html | Out-File $outputpath
C:\servers.htm
