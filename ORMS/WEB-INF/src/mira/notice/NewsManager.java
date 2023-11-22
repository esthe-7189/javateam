package mira.notice;

import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.io.IOException;

import java.io.Reader;
import java.io.StringReader;
import java.sql.Connection;

import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.sql.SQLException;

import mira.DBUtil;

import mira.sequence.Sequencer; 


public class NewsManager { 
    
    private static NewsManager instance = new NewsManager();
    
    public static NewsManager getInstance() {
        return instance;
    }
    
    private NewsManager() {}
    private static String POOLNAME = "pool";
    
    /** 새로운 글을 삽입한다.*/ 
 
		
		public void insert(NewsBean news) throws NewsManagerException { 
		Connection conn = null; 
		PreparedStatement pstmtInsert = null;        
        
        try {
            conn = DBUtil.getConnection(POOLNAME);                
			conn.setAutoCommit(false);
            // 새로운 글의 번호를 구한다.
            news.setSeq(Sequencer.nextId(conn, "notice"));
            // 글을 삽입한다.
            pstmtInsert = conn.prepareStatement( 
 "insert into notice values (?,?,?,?,?)");
            
			pstmtInsert.setInt(1, news.getSeq());
            pstmtInsert.setString(2, news.getTitle());
            pstmtInsert.setCharacterStream(3,  new StringReader(news.getContent()), news.getContent().length());
			pstmtInsert.setTimestamp(4, news.getRegister());                   
			pstmtInsert.setInt(5, news.getView_yn());                    
			pstmtInsert.executeUpdate(); 
			conn.commit();
            
        } catch(SQLException ex) {  try {conn.rollback();} catch(SQLException ex1) {}                
            throw new NewsManagerException("insert", ex);
        } finally {		
            if (pstmtInsert!= null)  try { pstmtInsert.close(); } catch(SQLException ex) {}            
            if (conn != null)    try {conn.setAutoCommit(true);   conn.close();  } catch(SQLException ex) {} 
        }
    }
    
    /** 
* 제목과 내용만 변경한다. */ 
    
		 public void update(NewsBean  news) throws NewsManagerException {
        Connection conn = null; 
        
		PreparedStatement pstmtUpdate = null;        
        
        try {
            conn = DBUtil.getConnection(POOLNAME);        
            conn.setAutoCommit(false);
            pstmtUpdate = conn.prepareStatement( "update notice set title=?,content=?,view_yn=? where seq=?");
                    
            pstmtUpdate.setString(1, news.getTitle());
            pstmtUpdate.setCharacterStream(2, new StringReader(news.getContent()), news.getContent().length());
            pstmtUpdate.setInt(3, news.getView_yn());            
            pstmtUpdate.setInt(4, news.getSeq());
            pstmtUpdate.executeUpdate();	    
            conn.commit();    
        } catch(SQLException ex) { 
			try {conn.rollback();} catch(SQLException ex1) {} 
            throw new NewsManagerException("update", ex);
        } finally { 
            
			if (pstmtUpdate != null) 
 	try { pstmtUpdate.close(); } catch(SQLException ex) {}            
            if (conn != null)  try {conn.setAutoCommit(true);   conn.close();  } catch(SQLException ex) {} 
        }
    }
    
    /** * 등록된 글의 개수를 구한다.  */ 
    
	public int count(List whereCond, Map valueMap)   throws NewsManagerException {
        if (valueMap == null) valueMap = Collections.EMPTY_MAP; 
        
        Connection conn = null; 
        
		PreparedStatement pstmt = null; 
        
		ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection(POOLNAME);
            StringBuffer query = new StringBuffer(200); 
            
			query.append("select count(*) from notice ");
            if (whereCond != null && whereCond.size() > 0) {
                query.append("where "); 
               
					for (int i = 0 ; i < whereCond.size() ; i++) {
							query.append(whereCond.get(i)); 
                    
							if (i < whereCond.size() -1 ) { 
                        
							query.append(" or ");
                    }
                }
            }
            pstmt = conn.prepareStatement(query.toString());
            
            Iterator keyIter = valueMap.keySet().iterator();
            while(keyIter.hasNext()) {
                Integer key = (Integer)keyIter.next();
                Object obj = valueMap.get(key); 
                
					if (obj instanceof String) {
                    pstmt.setString(key.intValue(), (String)obj);
					} else if (obj instanceof Integer) {
						pstmt.setInt(key.intValue(), ((Integer)obj).intValue());
					} else if (obj instanceof Timestamp) {
						pstmt.setTimestamp(key.intValue(), (Timestamp)obj);
					}
            }
            
            rs = pstmt.executeQuery();
            int count = 0;
            if (rs.next()) {
                count = rs.getInt(1);
            }
            return count;
        } catch(SQLException ex) {
            throw new NewsManagerException("count", ex);
        } finally { if (rs != null) try { rs.close(); } catch(SQLException ex) {} 
            if (pstmt != null) try { pstmt.close(); } catch(SQLException ex) {} 
            if (conn != null) try { conn.close(); } catch(SQLException ex) {} 
        }
    }
    
    /** 
     * 목록을 읽어온다. 
     */ 
    
	public List selectList(List whereCond, Map valueMap, int startRow, int endRow)
    throws NewsManagerException {
        if (valueMap == null) valueMap = Collections.EMPTY_MAP; 
   
			
        Connection conn = null; 
        
		PreparedStatement pstmt = null;
        ResultSet rs = null; 
        
        try {
            StringBuffer query = new StringBuffer(200); 
            
			query.append("select * from notice ");
            if (whereCond != null && whereCond.size() > 0) {
                query.append("where "); 
               
				for (int i = 0 ; i < whereCond.size() ; i++) {
                       query.append(whereCond.get(i)); 
                    
						if (i < whereCond.size() -1 ) { 
                        
						   query.append(" or ");
                    }
                }
            }
            query.append(" order by seq desc  limit ?, ?");
            
            conn = DBUtil.getConnection(POOLNAME);            
            pstmt = conn.prepareStatement(query.toString()); 
 
				
			Iterator keyIter = valueMap.keySet().iterator();
            while(keyIter.hasNext()) {
                Integer key = (Integer)keyIter.next();
                Object obj = valueMap.get(key); 
               
					if (obj instanceof String) {
						pstmt.setString(key.intValue(), (String)obj);
						 } else if (obj instanceof Integer) {
						pstmt.setInt(key.intValue(), 
                                        ((Integer)obj).intValue()); 
               
						} else if (obj instanceof Timestamp) {
						pstmt.setTimestamp(key.intValue(),
                                          (Timestamp)obj);
                }
            }
            
            pstmt.setInt(valueMap.size()+1, startRow);
            pstmt.setInt(valueMap.size()+2, endRow-startRow+1);
            
            rs = pstmt.executeQuery();
            if (rs.next()) { 
                
				List list = new java.util.ArrayList(endRow-startRow+1); 
  
				Reader reader2 = null;
                do {
                    NewsBean  news = new NewsBean();

                    news.setSeq(rs.getInt("seq"));
                    news.setTitle(rs.getString("title")); 
						try{
							reader2=rs.getCharacterStream("content");
							char[] buff=new char[512];
							int len=-1;
							StringBuffer buffer=new StringBuffer(512);
							while((len=reader2.read(buff)) != -1){
								buffer.append(buff,0,len);
							}
							news.setContent(buffer.toString());
						}catch (IOException iex){throw new NewsManagerException("content select",iex);}
						finally{if(reader2 !=null)try{reader2.close();}catch (IOException iex){}} 
				 
                    
					news.setRegister(rs.getTimestamp("register"));                           
                    news.setView_yn(rs.getInt("view_yn")); 
                   
					
                    list.add(news);
                } while(rs.next());
                
                return list;
                
            } else {
                return Collections.EMPTY_LIST;
            }
            
        } catch(SQLException ex) {
            throw new NewsManagerException("selectList", ex);
        } finally { 
			if (rs != null)
				try { rs.close(); } catch(SQLException ex) {} 
            if (pstmt != null) 
                try { pstmt.close(); } catch(SQLException ex) {} 
            if (conn != null) 
				try { conn.close(); } catch(SQLException ex) {} 
        }
    }
   /** 
     * 목록을 읽어온다. 
     */ 
    
	public List selectListMain(List whereCond, Map valueMap, int startRow, int endRow)
    throws NewsManagerException {
        if (valueMap == null) valueMap = Collections.EMPTY_MAP; 
   
			
        Connection conn = null; 
        
		PreparedStatement pstmt = null;
        ResultSet rs = null; 
        
        try {
            StringBuffer query = new StringBuffer(200); 
            
			query.append("select * from notice where view_yn=1 ");
            if (whereCond != null && whereCond.size() > 0) {
                query.append(" and "); 
               
				for (int i = 0 ; i < whereCond.size() ; i++) {
                       query.append(whereCond.get(i)); 
                    
						if (i < whereCond.size() -1 ) { 
                        
						   query.append(" or ");
                    }
                }
            }
            query.append(" order by seq desc  limit ?, ?");
            
            conn = DBUtil.getConnection(POOLNAME);            
            pstmt = conn.prepareStatement(query.toString()); 
 
				
			Iterator keyIter = valueMap.keySet().iterator();
            while(keyIter.hasNext()) {
                Integer key = (Integer)keyIter.next();
                Object obj = valueMap.get(key); 
               
					if (obj instanceof String) {
						pstmt.setString(key.intValue(), (String)obj);
						 } else if (obj instanceof Integer) {
						pstmt.setInt(key.intValue(), 
                                        ((Integer)obj).intValue()); 
               
						} else if (obj instanceof Timestamp) {
						pstmt.setTimestamp(key.intValue(),
                                          (Timestamp)obj);
                }
            }
            
            pstmt.setInt(valueMap.size()+1, startRow);
            pstmt.setInt(valueMap.size()+2, endRow-startRow+1);
            
            rs = pstmt.executeQuery();
            if (rs.next()) { 
                
				List list = new java.util.ArrayList(endRow-startRow+1); 
  
				Reader reader2 = null;
                do {
                    NewsBean  news = new NewsBean();

                    news.setSeq(rs.getInt("seq"));
                    news.setTitle(rs.getString("title")); 
						try{
							reader2=rs.getCharacterStream("content");
							char[] buff=new char[512];
							int len=-1;
							StringBuffer buffer=new StringBuffer(512);
							while((len=reader2.read(buff)) != -1){
								buffer.append(buff,0,len);
							}
							news.setContent(buffer.toString());
						}catch (IOException iex){throw new NewsManagerException("content select",iex);}
						finally{if(reader2 !=null)try{reader2.close();}catch (IOException iex){}} 
				 
                    
					news.setRegister(rs.getTimestamp("register"));                           
                    news.setView_yn(rs.getInt("view_yn")); 
                   
					
                    list.add(news);
                } while(rs.next());
                
                return list;
                
            } else {
                return Collections.EMPTY_LIST;
            }
            
        } catch(SQLException ex) {
            throw new NewsManagerException("selectList", ex);
        } finally { 
			if (rs != null)
				try { rs.close(); } catch(SQLException ex) {} 
            if (pstmt != null) 
                try { pstmt.close(); } catch(SQLException ex) {} 
            if (conn != null) 
				try { conn.close(); } catch(SQLException ex) {} 
        }
    } 
    /** * 지정한 글을 읽어온다. */ 
    
		 public NewsBean select(int seq) throws NewsManagerException {
        Connection conn = null;        
		PreparedStatement pstmt = null;
        ResultSet rs = null;  
		Reader reader2 = null;
        
        try {
            NewsBean  news = null; 
            
            conn = DBUtil.getConnection(POOLNAME);
            pstmt = conn.prepareStatement("select * from notice where seq = ?");
            pstmt.setInt(1, seq); 
			rs = pstmt.executeQuery();
            if (rs.next()) {   
				news= new NewsBean();

                news.setSeq(rs.getInt("seq"));
                news.setTitle(rs.getString("title")); 
						try{
							reader2=rs.getCharacterStream("content");
							char[] buff=new char[512];
							int len=-1;
							StringBuffer buffer=new StringBuffer(512);
							while((len=reader2.read(buff)) != -1){
								buffer.append(buff,0,len);
							}
							news.setContent(buffer.toString());
						}catch (IOException iex){throw new NewsManagerException("content select",iex);}
						finally{if(reader2 !=null)try{reader2.close();}catch (IOException iex){}}
                    
				news.setRegister(rs.getTimestamp("register"));                           
                news.setView_yn(rs.getInt("view_yn")); 
  

				return news;
            } else {  return null;   }
          
        } catch(SQLException ex) {
            throw new NewsManagerException("select", ex);
        } finally {             
			if (rs != null)  try { rs.close(); } catch(SQLException ex) {} 
            if (pstmt != null)  try { pstmt.close(); } catch(SQLException ex) {}             
            if (conn != null) try { conn.close(); } catch(SQLException ex) {} 
        }
    }

public void delete(int seq) throws NewsManagerException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection(POOLNAME);
            pstmt = conn.prepareStatement("delete from notice where seq = ?");
            pstmt.setInt(1, seq);
            pstmt.executeUpdate();
        } catch(SQLException ex) {
            throw new NewsManagerException("delete", ex);
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch(SQLException ex) {}
            if (conn != null) try { conn.close(); } catch(SQLException ex) {}
        }
    }

	/*조회수 구하기
	 public void readReplace(NewsBean  news) throws NewsManagerException {
        Connection conn = null;         
		PreparedStatement pstmt = null;        
        
        try {
            conn = DBUtil.getConnection(POOLNAME);
            pstmt = conn.prepareStatement( "update tnotice set  FCNT=FCNT+1 where FSEQ=?");           
            
            pstmt.setInt(1, notice.getNseq());
            pstmt.executeUpdate();
            
        } catch(SQLException ex) {            
            throw new NewsManagerException("update", ex);
        } finally {             
			if (pstmt != null) try {   pstmt.close(); } catch(SQLException ex) {}            
            if (conn != null) try {    conn.close();  } catch(SQLException ex) {} 
        }
    }
*/
 /**유저 목록을 읽어온다. */     
	public List  userList(List whereCond, Map valueMap, int startRow, int endRow)
    throws NewsManagerException {
        if (valueMap == null) valueMap = Collections.EMPTY_MAP; 			
        Connection conn = null;         
		PreparedStatement pstmt = null;
        ResultSet rs = null;         
        try {
            StringBuffer query = new StringBuffer(200);             
			query.append("select * from notice ");
            if (whereCond != null && whereCond.size() > 0) {
                query.append("where  view_yn=1 and ");                
				for (int i = 0 ; i < whereCond.size() ; i++) {
                       query.append(whereCond.get(i));                     
						if (i < whereCond.size() -1 ) { query.append(" or ");}
				 }
            }else if (whereCond == null && whereCond.size() < 0){
				query.append("where view_yn=1");
            }
            query.append(" order by seq desc  limit ?, ?");            
            conn = DBUtil.getConnection(POOLNAME);            
            pstmt = conn.prepareStatement(query.toString());  
				
			Iterator keyIter = valueMap.keySet().iterator();
            while(keyIter.hasNext()) {
                Integer key = (Integer)keyIter.next();
                Object obj = valueMap.get(key);                
					if (obj instanceof String) {
						pstmt.setString(key.intValue(), (String)obj);
						 } else if (obj instanceof Integer) {
						pstmt.setInt(key.intValue(), 
                                        ((Integer)obj).intValue()); 
               
						} else if (obj instanceof Timestamp) {
						pstmt.setTimestamp(key.intValue(),
                                          (Timestamp)obj);
                }
            }            
            pstmt.setInt(valueMap.size()+1, startRow);
            pstmt.setInt(valueMap.size()+2, endRow-startRow+1);
            
            rs = pstmt.executeQuery();
            if (rs.next()) {                 
				List list = new java.util.ArrayList(endRow-startRow+1); 
				Reader reader2 = null;
                
                do {
                    NewsBean  news = new NewsBean();

                    news.setSeq(rs.getInt("seq"));
					news.setTitle(rs.getString("title")); 
						try{
							reader2=rs.getCharacterStream("content");
							char[] buff=new char[512];
							int len=-1;
							StringBuffer buffer=new StringBuffer(512);
							while((len=reader2.read(buff)) != -1){
								buffer.append(buff,0,len);
							}
							news.setContent(buffer.toString());
						}catch (IOException iex){throw new NewsManagerException("content select",iex);}
						finally{if(reader2 !=null)try{reader2.close();}catch (IOException iex){}}
                    
					news.setRegister(rs.getTimestamp("register"));                           
					news.setView_yn(rs.getInt("view_yn"));      
					
                    list.add(news);
                } while(rs.next());                
                return list;                
            } else {
                return Collections.EMPTY_LIST;
            }            
        } catch(SQLException ex) {
            throw new NewsManagerException("selectList", ex);
        } finally { 
			if (rs != null)
				try { rs.close(); } catch(SQLException ex) {} 
            if (pstmt != null) 
                try { pstmt.close(); } catch(SQLException ex) {} 
            if (conn != null) 
				try { conn.close(); } catch(SQLException ex) {} 
        }
    }
}
