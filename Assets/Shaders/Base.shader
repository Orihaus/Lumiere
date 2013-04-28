Shader "Base" 
{
	Properties  
	{
		_DiffuseAmount ( "Diffuse Amount", Range( 0.0, 1.0 ) ) = 0.25
		_SpecBoost ( "Specular Amount", Range( 0.0, 2.5 ) ) = 1.0
		_Normalmap ( "Normalmap", 2D ) = "normal" {}
		_FresnelPower ( "Fresnel Power", Range( 0.0, 8.0 ) ) = 8.0
		_FresnelMult ( "Fresnel Multiplier", Range( 0.0, 5.0 ) ) = 0.75
		_FresnelDilute ( "Spec Main", Range( 0.0, 5.0 ) ) = 0.75
		_PrimaryBlob ( "Primary Blob", Range( 0.0, 1.0 ) ) = 1.0
		_SecondaryBlob ( "Secondary Blob", Range( 0.0, 1.0 ) ) = 0.125
		_Gloss ( "Gloss", Range( 0.0, 2.0 ) ) = 1.0
	}
	    
	SubShader 
	{
        Tags
        {
          "Queue"="Geometry" //+0
          "IgnoreProjector"="True"
          "RenderType"="Opaque"
        }

        Cull Back
        ZWrite On
        ZTest LEqual

		CGPROGRAM
		#pragma target 3.0 
		#pragma surface surf SimpleSpecular noambient novertexlights
		//fullforwardshadows approxview dualforward
		
		float _Shininess;
		float _Gloss;
		float _FresnelPower;
		float _FresnelMult;
		float _FresnelDilute;
		float _PrimaryBlob;
		float _SecondaryBlob;
		fixed _SpecBoost;
		
		fixed CalculateSpecular( fixed3 lDir, fixed3 vDir, fixed3 norm, fixed spec )
		{	
			float3 halfVector = normalize( lDir + vDir );
			
			float specDot = saturate( dot( halfVector, norm ) );
			float fresnelDot = min( 1.0, dot( vDir, norm ) );
			float rimCore = 1.0 - saturate( fresnelDot );
			
			float rim = pow( rimCore, _FresnelPower );
			rim *= specDot;
			float doubleSpec = ( _SecondaryBlob * pow( specDot, _Gloss * 16.0 ) ) + ( pow( specDot, _Gloss * 128.0 ) * _PrimaryBlob );
			
			return spec * ( ( ( _FresnelMult * rim ) + _FresnelDilute ) * doubleSpec );
		}
		
		fixed4 LightingSimpleSpecular( SurfaceOutput s, fixed3 lightDir, fixed3 viewDir, fixed atten ) 
		{
			fixed diff = saturate( dot( s.Normal, lightDir ) );
			fixed spec = CalculateSpecular( lightDir, viewDir, s.Normal, s.Specular );
			
			fixed4 c;
			c.rgb = ( s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec ) * atten;
			c.a = s.Alpha;
			
			return c;
		}
		
		struct Input 
		{
			float2 uv_Normalmap;
		};
	
	 	sampler2D _Normalmap;
		fixed _DiffuseAmount;

		void surf( Input IN, inout SurfaceOutput o ) 
		{
			o.Albedo = _DiffuseAmount;

			o.Normal = UnpackNormal( tex2D( _Normalmap, IN.uv_Normalmap ) );
			o.Specular = _SpecBoost;
		}
	
		ENDCG
	} 
	    
	Fallback "Diffuse"
}