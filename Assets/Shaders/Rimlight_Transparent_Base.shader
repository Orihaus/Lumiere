Shader "Rimlight_Transparent_Base"
{  
        Properties
        {
				_DiffuseAmount ( "Diffuse Amount", Range( 0.0, 1.0 ) ) = 0.25
                _RimColor( "Rim Color", Color ) = ( 0.89, 0.945, 1.0, 0.0 )
                _RimPower( "Rim Power", Range( 0.0,1.0 ) ) = 3.0
                _Shininess( "Shininess", Range( 0.00, 2 ) ) = 0.078125
                
                _Alpha( "Alpha", Range( 1.0, 0.00 ) ) = 1.0
                _AlphaOffset( "Alpha Offset", Range ( 0.0313725490196078, 0.00 ) ) = 0.01
                
				_AmbientRim ( "Ambient Rim", Range( 0.0, 1.0 ) ) = 0.0
				_FresnelPower ( "Fresnel Power", Range( 0.0, 8.0 ) ) = 8.0
				_FresnelMult ( "Fresnel Multiplier", Range( 0.0, 10.0 ) ) = 0.75
				_FresnelDilute ( "Spec Main", Range( 0.0, 5.0 ) ) = 0.75
				_PrimaryBlob ( "Primary Blob", Range( 0.0, 1.0 ) ) = 1.0
				_SecondaryBlob ( "Secondary Blob", Range( 0.0, 1.0 ) ) = 0.125
				_Gloss ( "Gloss", Range( 0.0, 2.0 ) ) = 1.0
        }      
   
        SubShader
        {
                Tags { "Queue" = "Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
 
                CGPROGRAM
       
				#pragma target 3.0 
                #pragma surface surf SimpleSpecular alpha noambient nolightmap
   
				float _Shininess; 
				float _Gloss;
				float _AmbientRim;
				float _FresnelPower;
				float _FresnelMult;
				float _FresnelDilute;
				float _PrimaryBlob;
				float _SecondaryBlob;
				
                float _Alpha;
                float _AlphaOffset;
     
                float4 _RimColor;
 
				fixed CalculateSpecular( fixed3 lDir, fixed3 vDir, fixed3 norm, fixed spec )
				{	
					float3 halfVector = normalize( lDir + vDir );
					
					float specDot = saturate( dot( halfVector, norm ) );
					float fresnelDot = min( 1.0, dot( vDir, norm ) );
					float rimCore = 1.0 - saturate( fresnelDot );
					
					float rim = pow( rimCore, _FresnelPower );
					rim *= specDot;
					float doubleSpec = ( _SecondaryBlob * pow( specDot, _Gloss * 16.0 ) ) + ( pow( specDot, _Gloss * 128.0 ) * _PrimaryBlob );
					
					return spec * ( ( rim * _AmbientRim ) + ( ( _FresnelMult * rim ) + _FresnelDilute ) * doubleSpec );
				}
				
				fixed4 LightingSimpleSpecular( SurfaceOutput s, fixed3 lightDir, fixed3 viewDir, fixed atten ) 
				{
					fixed diff = saturate( dot( s.Normal, lightDir ) );
					fixed spec = CalculateSpecular( lightDir, viewDir, s.Normal, _Shininess );
					
					fixed4 c;
					c.rgb = ( s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec ) * atten;
					c.a = s.Alpha;
					
					return _RimColor * c;
				}
       
                struct Input
                {
                        float3 viewDir;
                };

                float _RimPower;
                float _Ambient;
                float4 _Color;
				fixed _DiffuseAmount;
       
                void surf (Input IN, inout SurfaceOutput o)
                {
                        o.Albedo = _DiffuseAmount;
                        float rim = 1.0 - saturate( dot( normalize( IN.viewDir ), o.Normal ) );
                        //o.Emission = rim;
                        o.Alpha = _Alpha * pow ( rim, _RimPower ) + _AlphaOffset;
                }
                ENDCG
        }
        Fallback "Diffuse"
}