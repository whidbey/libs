VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "SHA256"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'    CopyRight (c) 2006 Kelly Ethridge
'
'    This file is part of VBCorLib.
'
'    VBCorLib is free software; you can redistribute it and/or modify
'    it under the terms of the GNU Library General Public License as published by
'    the Free Software Foundation; either version 2.1 of the License, or
'    (at your option) any later version.
'
'    VBCorLib is distributed in the hope that it will be useful,
'    but WITHOUT ANY WARRANTY; without even the implied warranty of
'    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'    GNU Library General Public License for more details.
'
'    You should have received a copy of the GNU Library General Public License
'    along with Foobar; if not, write to the Free Software
'    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
'
'    Module: SHA256
'

''
' Represents a standard interface for SHA-256 class implementations.
'
' @see SHA256Managed
'
Option Explicit

''
' Returns if the SHA-256 implementation can be reused after a final transformation.
'
' @return Returns True if an instance can be reused, False otherwise.
'
Public Property Get CanReuseTransform() As Boolean: End Property

''
' Returns if an SHA-256 implementation can transform multiple blocks at a time.
'
' @return Returns True if an instance can transform multiple blocks at once, False otherwise.
'
Public Property Get CanTransformMultipleBlocks() As Boolean: End Property

''
' Returns the final hash value generated after performing the hashing algorithm.
'
' @return A 32 byte array representing the final hash.
'
Public Property Get Hash() As Byte(): End Property

''
' Returns the size of the hash in bits.
'
' @return Returns 256 for SHA-256 hashes.
'
Public Property Get HashSize() As Long: End Property

''
' Returns the input block size used by the SHA-1 hash implementation.
'
' @return Returns the block size in bytes.
'
Public Property Get InputBlockSize() As Long: End Property

''
' Returns the output block size created by the SHA-1 hash implementation.
'
' @return Returns the block size in bytes.
'
Public Property Get OutputBlockSize() As Long: End Property

''
' Releases any resources used by the hash implementation.
'
Public Sub Clear(): End Sub

''
' Computes the hash for a give source.
'
' @param Source The source to compute the hash for.
' @param Index The starting index in a byte array to begin computing the hash.
' @param Count The number of bytes to use to compute the hash.
' @return A 32-byte array containing the computed hash.
' @remarks The Source can be either a byte-array or a Stream object.
' <p>If the source is a Stream object, then the hash continues to read the stream
' until no more data is can be read. The hash is computed from all data read from the stream.</p>
'
Public Function ComputeHash(ByRef Source As Variant, Optional ByRef Index As Variant, Optional ByRef Count As Variant) As Byte(): End Function

''
' Returns if the value is equal to this object instance.
'
' @param Value The value to compare against this instance.
' @return Returns True if the value and this instance are equal, False otherwise.
'
Public Function Equals(ByRef Value As Variant) As Boolean: End Function

''
' Returns a psuedo-unique number used to help identify this
' object in memory. The current method is to return the value
' obtained from ObjPtr. If a different method needs to be impelmented
' then change the method here in this function.
'
' @return Returns a number identifing this instance.
'
Public Function GetHashCode() As Long: End Function

''
' Resets the hashing algorithm to start again.
'
Public Sub Initialize(): End Sub

''
' Returns a string representation of this object instance.
' The default method simply returns the application name
' and class name in which this class resides.
'
' @return Returns a string representation of this instance.
'
Public Function ToString() As String: End Function

''
' Computes the hash for the specified block of data.
'
' @param InputBuffer The data to compute the hash from.
' @param InputOffset The starting index in the input data to compute the hash.
' @param InputCount The number of bytes to compute the hash from.
' @param OutputBuffer The array to place the input buffer bytes in.
' @param OutputOffset The starting index to beging copying the bytes to.
' @return The number of bytes processed.
' @remarks The OutputBuffer will contain the same data as the InputBuffer. No hash values are placed in the OutputBuffer.
' <p>If the OutputBuffer is a Null Array, or is the same array as the InputBuffer and the OutputOffset equals the InputOffset, then nothing is copied, however, the hash is still computed
' on the InputBuffer data.</p>
' <p>The TransformFinalBlock needs to be called to finish computing the hash, this method alone cannot compute the entire hash.</p>
'
Public Function TransformBlock(ByRef InputBuffer() As Byte, ByVal InputOffset As Long, ByVal InputCount As Long, ByRef OutputBuffer() As Byte, ByVal OutputOffset As Long) As Long: End Function

''
' Computes the final hash value.
'
' @param InputBuffer The final block of data to compute the hash for.
' @param InputOffset The index in the InputBuffer to begin computing data.
' @param InputCount The number of bytes to be processed.
' @return Returns the section of the InputBuffer that was processed.
' @remarks This does not return the computed hash value. A copy of the data that was
' process is returned. To retrieve the hash value, call the Hash property.
'
Public Function TransformFinalBlock(ByRef InputBuffer() As Byte, ByVal InputOffset As Long, ByVal InputCount As Long) As Byte(): End Function


