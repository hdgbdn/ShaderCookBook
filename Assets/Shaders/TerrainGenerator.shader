Shader "HudiShader/TerrainGenerator" {
	Properties {
		_MainTint("Diffuse Tint", Color) = (1,1,1,1)
		// Properties for terrain
		_ColorA("Terrain Color A", Color) = (1,1,1,1)
		_ColorB("Terrain Color B", Color) = (1,1,1,1)
		_RTexture("Red Channel Texture", 2D) = "white"{}
		_GTexture("Green Channel Texture", 2D) = "white"{}
		_BTexture("Blue Channel Texture", 2D) = "white"{}
		_ATexture("Alpha Channel Texture", 2D) = "white"{}
		_BlendTexture("Blent Texture", 2D) = "white"{}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Use Shader Model 4.0 to slove Too many texture interpolators error 
		#pragma target 4.0
		// Lambert 	
		#pragma surface surf Lambert


		float4 _MainTint;
		float4 _ColorA;
		float4 _ColorB;
		sampler2D _RTexture;
		sampler2D _GTexture;
		sampler2D _BTexture;
		sampler2D _ATexture;
		sampler2D _BlendTexture;

		struct Input {
			float2 uv_RTexture;
			float2 uv_GTexture;
			float2 uv_BTexture;
			float2 uv_ATexture;
			float2 uv_BlendTexture;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			float4 blendData = tex2D(_BlendTexture, IN.uv_BlendTexture);
			
			float4 rTexData = tex2D(_RTexture, IN.uv_RTexture);
			float4 gTexData = tex2D(_GTexture, IN.uv_GTexture);
			float4 bTexData = tex2D(_BTexture, IN.uv_BTexture);
			float4 aTexData = tex2D(_ATexture, IN.uv_ATexture);

			float4 finalColor;
			finalColor = (rTexData * blendData.r + gTexData * blendData.g + bTexData * blendData.b + aTexData * blendData.a) / 2;
			finalColor.a = 1.0;

			float4 terrainLayers = lerp(_ColorA, _ColorB, blendData.r);
			finalColor *= terrainLayers;
			finalColor = saturate(finalColor);
			o.Albedo = finalColor.rgb * _MainTint.rgb;
			o.Alpha = finalColor.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
