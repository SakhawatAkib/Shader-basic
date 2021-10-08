Shader "Unlit/Vertex offset"{
    Properties{
        _ColorA("Color A", Color) = (1, 1, 1, 1)
        _ColorB("Color B", Color) = (1, 1, 1, 1)
        _ColorStart("Color Start", Range(0,1)) = 0
        _ColorEnd("Color End", Range(0,1)) = 1
        _WaveAmp ("Wave Amplitude", Range(0,0.2)) = 0.1
        
    }
    SubShader{
        Tags{ 
            "RenderType"="Opaque" // tag to inform the render pipeline of what type this is
        }
        
        Pass{
            // Pass tags

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
           
            #include "UnityCG.cginc"

            #define TAU 6.28318530718

            float4 _ColorA;
            float4 _ColorB;
            float _ColorStart;    
            float _ColorEnd;
            float _WaveAmp;

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

                float waves = cos( (v.uv0.y - _Time.y * 0.1f ) * TAU * 5);

                v.vertex.y = waves * _WaveAmp;
                
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

                // return float4(i.uv,0,1);
                
                float waves = cos( (i.uv.y - _Time.y * 0.1f ) * TAU * 5) * 0.5 + 0.5;
                return waves;
            }
            ENDCG
        }
    }
}
