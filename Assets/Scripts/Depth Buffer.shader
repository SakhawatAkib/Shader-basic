Shader "Unlit/Depth Buffer"{
    Properties{
        _ColorA("Color A", Color) = (1, 1, 1, 1)
        _ColorB("Color B", Color) = (1, 1, 1, 1)
        _ColorStart("Color Start", Range(0,1)) = 0
        _ColorEnd("Color End", Range(0,1)) = 1
    }
    SubShader{
        Tags{ "RenderType"="Opaque" }
        
        Pass{
            // Pass tags
            
            ZWrite Off
            Blend One One  //additive
            
            
            // Blend DstColor Zero  // Multiply
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
           
            #include "UnityCG.cginc"

            #define TAU 6.28318530718

            float4 _ColorA;
            float4 _ColorB;
            float _ColorStart;    
            float _ColorEnd;

            //automatically filled out by Unity
            struct MeshData{ // per-vertex mesh data
                float4 vertex : POSITION; // vertex position
                float3 normals : NORMAL;
                float4 uv0 : TEXCOORD0; // uv0 diffuse/normal map textures
            };

            struct Interpolators{
                float4 vertex : SV_POSITION; // clip space position
                float3 normal : TEXCOORD0;
                float2 uv : TEXCOORD1;
                
            };


            Interpolators vert (MeshData v) {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex); // local space to clip space
                o.normal = UnityObjectToWorldNormal(v.normals); // just pass through
                o.uv = v.uv0; // pass through
                return o;
            }


            float InverseLerp( float a, float b, float v ){
                return  (v-a)/(b-a);
            }

            
            fixed4 frag (Interpolators i) : SV_Target{

                // blend between two colors based on the X UV coordinate
                // float t = saturate( InverseLerp( _ColorStart, _ColorEnd, i.uv.x) );
                // float t = abs( frac(i.uv.x * 5) * 2 -1 ); // First way to triangle wave

                // return i.uv.y;
                
                float offset = cos( i.uv.x * TAU * 5) * 0.01;
                
                float t = cos( (i.uv.y + offset - _Time.y * 0.1f ) * TAU * 5) * 0.5 + 0.5;
                t *= 1-i.uv.y;
                
                return t;
                
                // float4 outColor = lerp(_ColorA, _ColorB, t);
                // return outColor; 
            }
            ENDCG
        }
    }
}
