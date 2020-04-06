
#include "../Include/LineNotify.mqh"
#include "../Common/Common.mqh"

uchar uc_array[1000];

class CAlerts
{
   public:
      bool alert();
      bool check();
   private:
      bool setting();
      int send( string str_mess );
};

bool CAlerts::alert()
{
   if( !setting() ) return false;
   
   return true;
}

bool CAlerts::setting()
{
   string AccessToken = "P5RpvptQIxXQrSjNHDvHdfykciIt33qKTfIpDsccn3h";
   StringToCharArray( AccessToken, uc_array, 0 );
   SetAccessToken( uc_array );
   
   if( !ObjectCreate( str_alertName0, OBJ_HLINE, 0, Time[0], Close[0] ) ) return false;
   ObjectSet( str_alertName0, OBJPROP_STYLE, STYLE_DASHDOTDOT );
   ObjectSet( str_alertName0, OBJPROP_COLOR, clrRed );
   
   if( !ObjectCreate( str_alertName1, OBJ_HLINE, 0, Time[0], Close[5] ) ) return false;
   ObjectSet( str_alertName1, OBJPROP_STYLE, STYLE_DASHDOTDOT );
   ObjectSet( str_alertName1, OBJPROP_COLOR, clrBlue );
   
   
   return true;
}

bool CAlerts::check()
{
   double d_price0 = ObjectGet( str_alertName0, OBJPROP_PRICE1 );
   d_price0 = NormalizeDouble( d_price0, Digits() );
   double d_price1 = ObjectGet( str_alertName1, OBJPROP_PRICE1 );
   d_price1 = NormalizeDouble( d_price1, Digits() );
   
   if( d_price0 >= Close[0] )
   {   
      if( send( str_downMess ) == -9 )
         Alert( "Error : 送信の上限に達しました。" );
      else if( send( str_downMess ) == -1 )
         return false;
   }
   if( d_price1 <= Close[0] )
      if( send( str_upMess ) == -9 )
         Alert( "Error : 送信の上限に達しました。" );
      
   return true;
}

int CAlerts::send( string str_mess )
{
   int i_ret = 0;
   StringToCharArray( str_mess, uc_array, 0 );
   i_ret = LineNotify( uc_array );
   
   if( i_ret == 0 )
      Print( "LINEapp Send[", str_mess, "]" );
   else
      return -1;
   
   return i_ret;
}