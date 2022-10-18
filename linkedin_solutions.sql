-- LINKEDIN TEST Q1, FINDING CTR PER CAMPAIGN SOLUTION (CTR = #clicks/#impressions) : 
SELECT 
    campaign_id,
    SUM(CLK.num_clicks) / COUNT(CM.impression_id) AS ctr
FROM
    (SELECT 
        impression_id, SUM(no_clicks) AS num_clicks
    FROM
        clicks_table
    GROUP BY impression_id) CLK
        JOIN
    campaign_mapping CM ON CLK.impression_id = CM.impression_id
GROUP BY campaign_id;



# ---------------------------------------------------------------------------------------------------
-- LINKEDIN TEST Q2, TOP CREATORS SURVEY SOLUTION : 
-- (USING LIMIT)
SELECT posts_created FROM (
	(
		SELECT groupid, COUNT(memberid) AS member_count FROM 
			groups_members GROUP BY groupid ORDER BY member_count DESC LIMIT 3
	 ) MG RIGHT JOIN groups_member_engagement GME ON MG.groupid = GME.groupid
)ORDER BY posts_created DESC LIMIT 2;

-- (WITHOUT USING LIMIT USING ROW_NUMBER())
-- SELECT TOP 2 GROUPS BASED ON COUNT(memberid) FROM groups_members
-- JOIN WITH groups_member_engagement ON groupid
-- SELECT TOP 2 MEMBERS WITH MOST posts_created

SELECT TOPCRTS.posts_created FROM (
	SELECT GMS.groupid, 
    GMS.member_count, 
    GMS.group_rank, 
    GME.memberid, 
    GME.posts_created, 
    ROW_NUMBER() OVER(ORDER BY GME.posts_created DESC) AS creator_rank 
    FROM (
		SELECT groupid, 
        COUNT(memberid) AS member_count,
        ROW_NUMBER() OVER(ORDER BY COUNT(memberid) DESC) AS group_rank 
        FROM 
			groups_members GM 
            GROUP BY groupid 
            ORDER BY member_count DESC
	)GMS 
    RIGHT JOIN 
    groups_member_engagement GME 
    ON GMS.groupid = GME.groupid 
    ORDER BY GME.posts_created DESC
)TOPCRTS 
WHERE TOPCRTS.group_rank <= 2 AND TOPCRTS.creator_rank <= 2;


# ---------------------------------------------------------------------------------------------------
-- LINKEDIN TEST Q3, ONE GROUP FROM EACH AGE GROUP FOR TECHNOLOGY MEMBERS SOLUTION :
-- SELECT MEMBERS FROM groups_member_engagement TABLE WHERE industry = TECHNOLOGY AND GROUP BY groupid
-- JOIN ^ AND groups_dim ON groupid, GROUP BY group_age
-- SELECT groupid, group_age FROM ^ ORDER BY 
SELECT TOPGRPS.groupid, TOPGRPS.total_views, TOPGRPS.group_ranks, G.group_age FROM (
	SELECT 
		GME.groupid, 
        SUM(GME.post_views) AS total_views, 
        ROW_NUMBER() OVER(ORDER BY SUM(GME.post_views) DESC) AS group_ranks 
    FROM 
    groups_member_engagement GME 
    RIGHT JOIN groups_members GM 
    ON GME.memberid = GM.memberid 
    WHERE GM.industry = 'Media' 
    GROUP BY GME.groupid
)TOPGRPS LEFT JOIN groups_dim G ON TOPGRPS.groupid = G.groupid;

# ---------------------------------------------------------------------------------------------------
-- LINKEDIN TEST Q4, (DISAP)/PROVE THE HYPOTHESIS THAT MORE ADMINS EQUAL MORE GROUP GROWTH BY COMPARING THE GROUP GROWTH OVER MULTIPLE MONTS 
-- USING posts_created AS METRIC:

-- PROBABLY THE HARDEST OF ALL THE ABOVE
-- LET'S SEE, HOW'LL WE GO ABOUT THIS


